#!/bin/bash

# Bulletproof Dotfiles Installation Script
# This script will forcefully install everything needed

set -e

echo "🚀 Starting bulletproof dotfiles installation..."
echo "This will take a few minutes and install everything needed."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the dotfiles directory
if [ ! -f "bulletproof_install.sh" ]; then
    print_error "Please run this script from the dotfiles directory"
    print_error "cd ~/dotfiles && ./bulletproof_install.sh"
    exit 1
fi

DOTFILES_DIR="$(pwd)"
print_status "Using dotfiles directory: $DOTFILES_DIR"

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_status "Created backup directory: $BACKUP_DIR"

# Backup existing files
print_status "Backing up existing configuration files..."
for file in .zshrc .zshenv .zprofile .bashrc .bash_profile .p10k.zsh .fzf.zsh .fzf.bash .gitconfig .gitignore_global; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        print_success "Backed up $file"
    fi
done

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Install essential tools
print_status "Installing essential tools via Homebrew..."
brew install git curl wget zsh fzf starship

# Install Oh My Zsh (force reinstall to ensure it's clean)
print_status "Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh already exists, removing old installation..."
    rm -rf "$HOME/.oh-my-zsh"
fi

# Install Oh My Zsh non-interactively
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
print_success "Oh My Zsh installed"

# Install Powerlevel10k theme
print_status "Installing Powerlevel10k theme..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_warning "Powerlevel10k already exists, updating..."
    cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    git pull
    cd "$DOTFILES_DIR"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi
print_success "Powerlevel10k installed"

# Install fzf properly
print_status "Installing fzf..."
if [ -d "$HOME/.fzf" ]; then
    print_warning "fzf directory exists, removing..."
    rm -rf "$HOME/.fzf"
fi
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-fish
print_success "fzf installed"

# Install NVM
print_status "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "NVM installed"
else
    print_success "NVM already installed"
fi

# Restore dotfiles with force
print_status "Restoring dotfiles..."
cp "$DOTFILES_DIR/backup/.zshrc" "$HOME/.zshrc"
print_success "Restored .zshrc"

cp "$DOTFILES_DIR/backup/.p10k.zsh" "$HOME/.p10k.zsh"
print_success "Restored .p10k.zsh"

cp "$DOTFILES_DIR/backup/.zshenv" "$HOME/.zshenv"
print_success "Restored .zshenv"

cp "$DOTFILES_DIR/backup/.zprofile" "$HOME/.zprofile"
print_success "Restored .zprofile"

cp "$DOTFILES_DIR/backup/.fzf.zsh" "$HOME/.fzf.zsh"
print_success "Restored .fzf.zsh"

if [ -f "$DOTFILES_DIR/backup/.fzf.bash" ]; then
    cp "$DOTFILES_DIR/backup/.fzf.bash" "$HOME/.fzf.bash"
    print_success "Restored .fzf.bash"
fi

if [ -f "$DOTFILES_DIR/backup/.bashrc" ]; then
    cp "$DOTFILES_DIR/backup/.bashrc" "$HOME/.bashrc"
    print_success "Restored .bashrc"
fi

cp "$DOTFILES_DIR/backup/.gitconfig" "$HOME/.gitconfig"
print_success "Restored .gitconfig"

if [ -f "$DOTFILES_DIR/backup/.gitignore_global" ]; then
    cp "$DOTFILES_DIR/backup/.gitignore_global" "$HOME/.gitignore_global"
    print_success "Restored .gitignore_global"
fi

# Set up Starship config
mkdir -p "$HOME/.config"
if [ -f "$DOTFILES_DIR/backup/starship.toml" ]; then
    cp "$DOTFILES_DIR/backup/starship.toml" "$HOME/.config/starship.toml"
    print_success "Restored Starship configuration"
fi

# Create .env file
if [ ! -f "$HOME/.env" ]; then
    cp "$DOTFILES_DIR/backup/.env.template" "$HOME/.env"
    print_success "Created .env from template"
    print_warning "Don't forget to add your API keys to ~/.env"
else
    print_success ".env already exists"
fi

# Change default shell to zsh if needed
if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/local/bin/zsh" ] && [ "$SHELL" != "/opt/homebrew/bin/zsh" ]; then
    print_status "Changing default shell to zsh..."
    chsh -s /bin/zsh
    print_success "Default shell changed to zsh"
fi

# Force reload environment
print_status "Setting up environment for current session..."
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Verification
print_status "Verifying installation..."
echo ""
echo "=== VERIFICATION ==="

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "✓ Oh My Zsh installed"
else
    print_error "✗ Oh My Zsh missing"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_success "✓ Powerlevel10k installed"
else
    print_error "✗ Powerlevel10k missing"
fi

if [ -f "$HOME/.zshrc" ]; then
    if grep -q "powerlevel10k/powerlevel10k" "$HOME/.zshrc"; then
        print_success "✓ .zshrc configured with Powerlevel10k"
    else
        print_error "✗ .zshrc not configured properly"
    fi
else
    print_error "✗ .zshrc missing"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    print_success "✓ Powerlevel10k configuration exists"
else
    print_error "✗ Powerlevel10k configuration missing"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
print_warning "IMPORTANT: You MUST do the following:"
echo "   1. Close this terminal completely"
echo "   2. Open a brand new terminal application"
echo "   3. You should see the Powerlevel10k prompt"
echo "   4. If prompted, run: p10k configure"
echo ""
print_status "Test commands for new terminal:"
echo "   echo \$ZSH_THEME    # Should show: powerlevel10k/powerlevel10k"
echo "   k --help           # Should show kubectl help (if kubectl installed)"
echo "   Ctrl+R             # Should show fzf history search"
echo ""
print_warning "If it still doesn't work, run:"
echo "   source ~/.zshrc"
echo "   echo \$ZSH_THEME"
echo ""
