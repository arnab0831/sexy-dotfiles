#!/bin/bash

# Simple one-command setup for other machines
# Run this on a fresh machine:
# curl -sSL https://raw.githubusercontent.com/arnab0831/sexy-dotfiles/main/setup_other_machine.sh | bash

echo "🚀 Setting up sexy dotfiles on new machine..."

# Clone dotfiles
if [ ! -d "$HOME/dotfiles" ]; then
    echo "📦 Cloning dotfiles repository..."
    git clone https://github.com/arnab0831/sexy-dotfiles.git ~/dotfiles
else
    echo "📦 Updating dotfiles repository..."
    cd ~/dotfiles && git pull
fi

# Make scripts executable
chmod +x ~/dotfiles/*.sh

# Run the bulletproof installer
cd ~/dotfiles
./bulletproof_install.sh

echo ""
echo "🎉 Setup complete! Now close this terminal and open a new one!"
