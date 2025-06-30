#!/bin/bash

# Manual Shell Configuration Fix Script
# This script ensures all dotfiles are properly applied

set -e

echo "🔧 Fixing shell configuration..."

# Backup current files
echo "💾 Creating backup of current files..."
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for file in .zshrc .zshenv .zprofile .bashrc .p10k.zsh .fzf.zsh .gitconfig; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        echo "📁 Backed up $file"
    fi
done

# Restore dotfiles
echo "📁 Restoring dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"

if [ -f "$DOTFILES_DIR/backup/.zshrc" ]; then
    cp "$DOTFILES_DIR/backup/.zshrc" "$HOME/.zshrc"
    echo "✅ Restored .zshrc"
fi

if [ -f "$DOTFILES_DIR/backup/.p10k.zsh" ]; then
    cp "$DOTFILES_DIR/backup/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "✅ Restored .p10k.zsh"
fi

if [ -f "$DOTFILES_DIR/backup/.zshenv" ]; then
    cp "$DOTFILES_DIR/backup/.zshenv" "$HOME/.zshenv"
    echo "✅ Restored .zshenv"
fi

if [ -f "$DOTFILES_DIR/backup/.zprofile" ]; then
    cp "$DOTFILES_DIR/backup/.zprofile" "$HOME/.zprofile"
    echo "✅ Restored .zprofile"
fi

if [ -f "$DOTFILES_DIR/backup/.fzf.zsh" ]; then
    cp "$DOTFILES_DIR/backup/.fzf.zsh" "$HOME/.fzf.zsh"
    echo "✅ Restored .fzf.zsh"
fi

if [ -f "$DOTFILES_DIR/backup/.gitconfig" ]; then
    cp "$DOTFILES_DIR/backup/.gitconfig" "$HOME/.gitconfig"
    echo "✅ Restored .gitconfig"
fi

# Create .env file if it doesn't exist
if [ ! -f "$HOME/.env" ]; then
    cp "$DOTFILES_DIR/backup/.env.template" "$HOME/.env"
    echo "✅ Created .env from template"
    echo "⚠️  Don't forget to add your API keys to ~/.env"
fi

# Create Starship config directory and file
mkdir -p "$HOME/.config"
if [ -f "$DOTFILES_DIR/backup/starship.toml" ]; then
    cp "$DOTFILES_DIR/backup/starship.toml" "$HOME/.config/starship.toml"
    echo "✅ Restored Starship configuration"
fi

# Check if required tools are installed
echo "🔍 Checking required tools..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh found"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "❌ Powerlevel10k not found. Installing..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "✅ Powerlevel10k found"
fi

if [ ! -d "$HOME/.fzf" ]; then
    echo "❌ fzf not found. Installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "✅ fzf found"
fi

if ! command -v starship &> /dev/null; then
    echo "❌ Starship not found. Installing..."
    curl -sS https://starship.rs/install.sh | sh
else
    echo "✅ Starship found"
fi

# Force reload the shell configuration
echo "🔄 Reloading shell configuration..."
export ZSH="$HOME/.oh-my-zsh"
source "$HOME/.zshrc" 2>/dev/null || echo "Note: Some configurations require a new terminal session"

echo ""
echo "🎉 Shell configuration fix complete!"
echo ""
echo "💡 Next steps:"
echo "   1. Open a NEW terminal window/tab"
echo "   2. You should see the Powerlevel10k prompt"
echo "   3. If prompted, configure Powerlevel10k: p10k configure"
echo "   4. Edit ~/.env to add your API keys"
echo ""
echo "🔧 If you still don't see the theme:"
echo "   1. Run: echo \$ZSH_THEME"
echo "   2. Run: source ~/.zshrc"
echo "   3. Open a completely new terminal application"
echo ""
