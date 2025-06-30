#!/bin/bash

# 🔥 ULTIMATE FRESH LAPTOP SETUP SCRIPT 🔥
# For brand new MacBook - assumes NOTHING is installed
# Run this with: curl -sSL https://raw.githubusercontent.com/arnab0831/sexy-dotfiles/main/fresh_laptop_setup.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}===================================================${NC}"
    echo -e "${PURPLE}🔥 $1 🔥${NC}"
    echo -e "${PURPLE}===================================================${NC}"
}

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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only!"
    exit 1
fi

print_header "FRESH MACBOOK SETUP - ULTIMATE EDITION"
echo ""
echo "This script will:"
echo "  🍺 Install Homebrew (package manager)"
echo "  🛠️  Install essential development tools"
echo "  🐚 Install Oh My Zsh + Powerlevel10k theme"
echo "  🔍 Install fzf (fuzzy finder)"
echo "  ⭐ Install Starship prompt"
echo "  📦 Install Node.js (via NVM)"
echo "  🐍 Set up Python environment"
echo "  🔧 Install useful CLI tools"
echo "  🎨 Apply your sexy dotfiles configuration"
echo ""
print_warning "This will take 10-15 minutes. Get some coffee! ☕"
echo ""
read -p "Ready to transform your laptop? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled. Run again when ready!"
    exit 0
fi

# Install Xcode Command Line Tools (required for everything)
print_header "INSTALLING XCODE COMMAND LINE TOOLS"
if ! command -v git &> /dev/null; then
    print_status "Installing Xcode Command Line Tools..."
    xcode-select --install 2>/dev/null || true
    
    # Wait for installation to complete
    print_status "Waiting for Xcode Command Line Tools installation..."
    while ! command -v git &> /dev/null; do
        sleep 5
        print_status "Still waiting for git to be available..."
    done
    print_success "Xcode Command Line Tools installed!"
else
    print_success "Xcode Command Line Tools already installed"
fi

# Install Homebrew
print_header "INSTALLING HOMEBREW"
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew (this may take a while)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
    print_success "Homebrew installed and configured!"
else
    print_success "Homebrew already installed"
    # Update Homebrew
    print_status "Updating Homebrew..."
    brew update
fi

# Install essential tools via Homebrew
print_header "INSTALLING ESSENTIAL TOOLS"
print_status "Installing development tools..."

# Core tools
brew install git curl wget zsh

# Development tools
brew install node python@3.11 go rust

# CLI utilities
brew install fzf starship tree bat eza jq htop neofetch

# Optional but useful tools
brew install --cask rectangle  # Window management
brew install --cask warp       # Terminal (if they want it)

print_success "Essential tools installed!"

# Install Oh My Zsh
print_header "INSTALLING OH MY ZSH"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed!"
else
    print_warning "Oh My Zsh already exists, skipping..."
fi

# Install Powerlevel10k
print_header "INSTALLING POWERLEVEL10K THEME"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_status "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_success "Powerlevel10k installed!"
else
    print_warning "Powerlevel10k already exists, updating..."
    cd "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    git pull
    cd -
fi

# Install fzf
print_header "SETTING UP FZF"
if [ ! -d "$HOME/.fzf" ]; then
    print_status "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    print_success "fzf installed!"
else
    print_warning "fzf already exists, skipping..."
fi

# Install NVM and Node.js
print_header "INSTALLING NODE.JS ENVIRONMENT"
if [ ! -d "$HOME/.nvm" ]; then
    print_status "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Load NVM for this session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    print_status "Installing latest Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    print_success "Node.js environment ready!"
else
    print_success "NVM already installed"
fi

# Clone and set up dotfiles
print_header "SETTING UP YOUR SEXY DOTFILES"
if [ ! -d "$HOME/dotfiles" ]; then
    print_status "Cloning your dotfiles repository..."
    git clone https://github.com/arnab0831/sexy-dotfiles.git ~/dotfiles
else
    print_status "Updating dotfiles repository..."
    cd ~/dotfiles && git pull && cd -
fi

# Backup existing configs
print_status "Creating backup of existing configs..."
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for file in .zshrc .zshenv .zprofile .bashrc .bash_profile .p10k.zsh .gitconfig; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        print_success "Backed up $file"
    fi
done

# Apply dotfiles
print_status "Applying your sexy configuration..."
cd ~/dotfiles

# Copy all dotfiles
cp backup/.zshrc "$HOME/.zshrc"
cp backup/.p10k.zsh "$HOME/.p10k.zsh"
cp backup/.zshenv "$HOME/.zshenv"
cp backup/.zprofile "$HOME/.zprofile"
cp backup/.fzf.zsh "$HOME/.fzf.zsh"
cp backup/.gitconfig "$HOME/.gitconfig"

# Set up other configs
mkdir -p "$HOME/.config"
if [ -f "backup/starship.toml" ]; then
    cp backup/starship.toml "$HOME/.config/starship.toml"
fi

# Create .env from template
if [ ! -f "$HOME/.env" ]; then
    cp backup/.env.template "$HOME/.env"
    print_warning "Created .env file - add your API keys later!"
fi

print_success "Dotfiles applied!"

# Configure Git (basic setup)
print_header "GIT CONFIGURATION"
if ! git config --global user.name &> /dev/null; then
    echo ""
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    print_success "Git configured!"
else
    print_success "Git already configured"
fi

# Set zsh as default shell
print_header "SETTING ZSH AS DEFAULT SHELL"
if [ "$SHELL" != "/bin/zsh" ]; then
    print_status "Changing default shell to zsh..."
    chsh -s /bin/zsh
    print_success "Default shell changed to zsh!"
else
    print_success "Already using zsh as default shell"
fi

# Install additional useful packages
print_header "INSTALLING ADDITIONAL DEVELOPMENT TOOLS"
print_status "Installing useful development packages..."

# Install pnpm (fast package manager)
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Install Rust tools
if command -v cargo &> /dev/null; then
    cargo install ripgrep fd-find
fi

print_success "Additional tools installed!"

# Final verification
print_header "VERIFICATION"
echo ""
echo "=== INSTALLATION VERIFICATION ==="
echo ""

# Check installations
tools=("brew" "git" "node" "python3.11" "go" "rustc" "fzf" "starship" "tree" "bat")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "✓ $tool installed"
    else
        print_warning "✗ $tool not found"
    fi
done

# Check Oh My Zsh and theme
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "✓ Oh My Zsh installed"
else
    print_error "✗ Oh My Zsh missing"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_success "✓ Powerlevel10k theme installed"
else
    print_error "✗ Powerlevel10k theme missing"
fi

if [ -f "$HOME/.zshrc" ] && grep -q "powerlevel10k" "$HOME/.zshrc"; then
    print_success "✓ Configuration files applied"
else
    print_error "✗ Configuration not properly applied"
fi

print_header "🎉 SETUP COMPLETE! 🎉"
echo ""
print_success "Your MacBook is now configured with:"
echo "  🍺 Homebrew package manager"
echo "  🛠️  Essential development tools (Node.js, Python, Go, Rust)"
echo "  🐚 Oh My Zsh with Powerlevel10k theme"
echo "  🔍 fzf fuzzy finder"
echo "  ⭐ Starship prompt"
echo "  🎨 Your sexy dotfiles configuration"
echo ""
print_warning "IMPORTANT NEXT STEPS:"
echo "  1. Close this terminal completely"
echo "  2. Open a new terminal app"
echo "  3. You should see the Powerlevel10k configuration wizard"
echo "  4. Run through the configuration (choose what looks good to you)"
echo "  5. Edit ~/.env to add your API keys"
echo ""
print_status "Useful commands to try:"
echo "  • neofetch           # Show system info"
echo "  • k --help          # kubectl shortcuts (if you install kubectl)"
echo "  • Ctrl+R            # fzf history search"
echo "  • tree              # Show directory structure"
echo ""
print_success "Welcome to your new development environment! 🚀"
