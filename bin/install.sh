#!/usr/bin/env bash
# Install dotfiles into $HOME. Safe to re-run: existing links are repointed,
# real files in the way are backed up, and rc source lines are never duplicated.
#
# Each tool directory holds files named as they appear in $HOME
# (e.g. git/.gitconfig -> ~/.gitconfig). shell/*-private files are sourced
# from ~/.bashrc and ~/.bash_profile rather than linked.
set -euo pipefail

# Repository root, wherever it is cloned
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Tool directories whose dotfiles are linked into $HOME
TOOLS="git ruby shell tmux vim"

# Point <dest> (default $HOME/<name>) at <src>, backing up a real file that is in the way
link() {
  local src="$1" dest="${2:-$HOME/$(basename "$1")}"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "backed up $dest"
  fi
  ln -sfn "$src" "$dest"
}

# Make <rc file> source <private file> exactly once, repointing an old path if present
ensure_source() {
  local rc="$HOME/$1" private="$2"
  local name; name="$(basename "$private")"
  local line="source $private"
  touch "$rc"
  if grep -qxF "$line" "$rc"; then
    return
  elif grep -qE "^source .*/$name\$" "$rc"; then
    sed -i.bak -E "s#^source .*/$name\$#$line#" "$rc" && rm "$rc.bak"
  else
    printf '\n# Link to personal\n%s\n' "$line" >> "$rc"
  fi
}

# Remove broken links in <dir> (default $HOME dotfiles) that pointed into this repo
# (or its old bootstrap-rc name)
remove_dangling_links() {
  local file target pattern="${1:-$HOME/.[!.]*}"
  for file in $pattern; do
    [ -L "$file" ] && [ ! -e "$file" ] || continue
    target="$(readlink "$file")"
    case "$target" in
      "$DIR"/*|*/bootstrap-rc/*) rm "$file" && echo "removed dangling $file" ;;
    esac
  done
}

remove_dangling_links

# Dotfiles from each tool directory
for tool in $TOOLS; do
  for file in "$DIR/$tool"/.[!.]*; do
    [ -e "$file" ] || continue
    case "$(basename "$file")" in
      *-private) ;;  # sourced below, not linked
      *) link "$file" ;;
    esac
  done
done

# Shell
ensure_source .bash_profile "$DIR/shell/.bash_profile-private"
ensure_source .bashrc "$DIR/shell/.bashrc-private"

# Skills: link each committed skill into Claude Code and Codex, so drafts
# stay out of use until they are committed
for skills_dir in "$HOME/.claude/skills" "$HOME/.codex/skills"; do
  mkdir -p "$skills_dir"
  remove_dangling_links "$skills_dir/*"
  git -C "$DIR" ls-files 'agents/skills/*/SKILL.md' | while read -r skill; do
    name="$(basename "$(dirname "$skill")")"
    link "$DIR/agents/skills/$name" "$skills_dir/$name"
  done
done

# Codex prompts: link each committed prompt into ~/.codex/prompts
mkdir -p "$HOME/.codex/prompts"
remove_dangling_links "$HOME/.codex/prompts/*"
git -C "$DIR" ls-files 'codex/prompts/*.md' | while read -r prompt; do
  link "$DIR/$prompt" "$HOME/.codex/prompts/$(basename "$prompt")"
done

# Vim bundles
git -C "$DIR" submodule update --init
