#!/usr/bin/env bash
# Install dotfiles into $HOME. Safe to re-run: existing links are repointed,
# real files in the way are backed up, and rc source lines are never duplicated.
set -euo pipefail

# Repository root, wherever it is cloned
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# Point $HOME/<name> at $DIR/<name>, backing up a real file that is in the way
link() {
  local src="$DIR/$1" dest="$HOME/$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "backed up $dest"
  fi
  ln -sfn "$src" "$dest"
}

# Make <rc file> source $DIR/<private file> exactly once, repointing an old path if present
ensure_source() {
  local rc="$HOME/$1" private="$2"
  local line="source $DIR/$private"
  touch "$rc"
  if grep -qxF "$line" "$rc"; then
    return
  elif grep -qE "^source .*/$private\$" "$rc"; then
    sed -i.bak -E "s#^source .*/$private\$#$line#" "$rc" && rm "$rc.bak"
  else
    printf '\n# Link to personal\n%s\n' "$line" >> "$rc"
  fi
}

# Remove links in $HOME whose target no longer exists (e.g. a deleted alias file)
remove_dangling_alias_links() {
  local file
  for file in "$HOME"/.*_alias; do
    if [ -L "$file" ] && [ ! -e "$file" ]; then
      rm "$file"
      echo "removed dangling $file"
    fi
  done
}

# Aliases
remove_dangling_alias_links
for alias in "$DIR"/.*_alias; do
  link "$(basename "$alias")"
done

# Shell
ensure_source .bash_profile .bash_profile-private
ensure_source .bashrc .bashrc-private

# Git, input, ruby, tmux, vim
for file in .gitconfig .inputrc .irbrc .pryrc .tmux.conf .ackrc .vim .vimrc; do
  link "$file"
done

# Vim bundles
git -C "$DIR" submodule update --init
