#!/bin/bash

# Quick Fix Script - Simple version that definitely works
# Run this if fresh_laptop_setup.sh has issues

echo "🔧 Quick Fix - Installing dotfiles..."

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
fi

# Install basic tools
echo "Installing basic tools..."
brew install git curl wget zsh fzf starship

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Clone dotfiles if not already done
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/arnab0831/sexy-dotfiles.git ~/dotfiles
fi

# Apply dotfiles
echo "Applying dotfiles..."
cd ~/dotfiles
cp backup/.zshrc "$HOME/.zshrc"
cp backup/.p10k.zsh "$HOME/.p10k.zsh" 2>/dev/null || true
cp backup/.zshenv "$HOME/.zshenv" 2>/dev/null || true
cp backup/.zprofile "$HOME/.zprofile" 2>/dev/null || true

# Create .env
if [ ! -f "$HOME/.env" ]; then
    cp backup/.env.template "$HOME/.env" 2>/dev/null || true
fi

echo ""
echo "✅ Quick fix complete!"
echo "📋 Next steps:"
echo "  1. Close this terminal"
echo "  2. Open a new terminal" 
echo "  3. You should see Powerlevel10k prompt"
echo ""
