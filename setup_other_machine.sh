#!/bin/bash

# Simple one-command setup for other machines
# For EXISTING machines with some tools already installed:
# curl -sSL https://raw.githubusercontent.com/arnab0831/sexy-dotfiles/main/setup_other_machine.sh | bash
#
# For BRAND NEW laptops, use this instead:
# curl -sSL https://raw.githubusercontent.com/arnab0831/sexy-dotfiles/main/fresh_laptop_setup.sh | bash

echo "🚀 Setting up sexy dotfiles on existing machine..."
echo "💡 Note: For brand new laptops, use fresh_laptop_setup.sh instead!"
echo ""

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
