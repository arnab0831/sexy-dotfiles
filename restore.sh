#!/bin/bash

# Dotfiles Restore Script
# This script restores your shell configuration and Warp settings

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup"

echo "🔄 Starting dotfiles restore..."

# Backup existing files before restore
echo "💾 Creating backup of existing files..."
mkdir -p "$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
EXISTING_BACKUP="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

for file in .zshrc .zshenv .zprofile .bashrc .bash_profile .p10k.zsh .fzf.zsh .fzf.bash .gitconfig .gitignore_global; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$EXISTING_BACKUP/$file"
        echo "📁 Backed up existing $file"
    fi
done

# Restore files
echo "📁 Restoring shell configuration files..."
for file in .zshrc .zshenv .zprofile .bashrc .bash_profile .p10k.zsh .fzf.zsh .fzf.bash .gitconfig .gitignore_global; do
    if [ -f "$BACKUP_DIR/$file" ]; then
        cp "$BACKUP_DIR/$file" "$HOME/$file"
        echo "✅ Restored $file"
    fi
done

echo "🎉 Dotfiles restored successfully!"
echo "💡 Don't forget to:"
echo "   1. Install Oh My Zsh: sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
echo "   2. Install Powerlevel10k: git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo "   3. Install fzf: git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
echo "   4. Install Starship: curl -sS https://starship.rs/install.sh | sh"
echo "   5. Restart your terminal or run: source ~/.zshrc"
