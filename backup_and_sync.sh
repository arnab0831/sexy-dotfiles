#!/bin/bash

# Dotfiles Backup and Sync Script
# This script backs up your shell configuration and Warp settings

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/backup"
WARP_BACKUP_DIR="$DOTFILES_DIR/warp"

echo "🚀 Starting dotfiles backup..."

# Create directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$WARP_BACKUP_DIR"

# Backup shell configuration files
echo "📁 Backing up shell configuration files..."
cp ~/.zshrc "$BACKUP_DIR/.zshrc" 2>/dev/null || echo "⚠️  .zshrc not found"
cp ~/.zshenv "$BACKUP_DIR/.zshenv" 2>/dev/null || echo "⚠️  .zshenv not found"
cp ~/.zprofile "$BACKUP_DIR/.zprofile" 2>/dev/null || echo "⚠️  .zprofile not found"
cp ~/.bashrc "$BACKUP_DIR/.bashrc" 2>/dev/null || echo "⚠️  .bashrc not found"
cp ~/.bash_profile "$BACKUP_DIR/.bash_profile" 2>/dev/null || echo "⚠️  .bash_profile not found"

# Backup Powerlevel10k configuration
echo "🎨 Backing up Powerlevel10k configuration..."
cp ~/.p10k.zsh "$BACKUP_DIR/.p10k.zsh" 2>/dev/null || echo "⚠️  .p10k.zsh not found"

# Backup fzf configuration
echo "🔍 Backing up fzf configuration..."
cp ~/.fzf.zsh "$BACKUP_DIR/.fzf.zsh" 2>/dev/null || echo "⚠️  .fzf.zsh not found"
cp ~/.fzf.bash "$BACKUP_DIR/.fzf.bash" 2>/dev/null || echo "⚠️  .fzf.bash not found"

# Backup git configuration
echo "📝 Backing up git configuration..."
cp ~/.gitconfig "$BACKUP_DIR/.gitconfig" 2>/dev/null || echo "⚠️  .gitconfig not found"
cp ~/.gitignore_global "$BACKUP_DIR/.gitignore_global" 2>/dev/null || echo "⚠️  .gitignore_global not found"

# Export Warp settings (if Warp is installed)
if [ -d "$HOME/Library/Application Support/dev.warp.Warp-Stable" ]; then
    echo "🌊 Backing up Warp settings..."
    
    # Create a script to extract Warp settings
    cat > "$WARP_BACKUP_DIR/extract_warp_settings.sql" << 'EOF'
.mode insert
.output warp_settings.sql
SELECT sql FROM sqlite_master WHERE type='table';
.output warp_themes.sql  
SELECT * FROM themes;
.output warp_keybindings.sql
SELECT * FROM keybindings;
.output warp_workflows.sql
SELECT * FROM workflows;
.output warp_preferences.sql
SELECT * FROM preferences;
EOF

    # Extract settings from Warp's SQLite database
    cd "$WARP_BACKUP_DIR"
    sqlite3 "$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite" < extract_warp_settings.sql 2>/dev/null || echo "⚠️  Could not extract Warp settings"
    cd - > /dev/null
    
    echo "✅ Warp settings exported to $WARP_BACKUP_DIR"
else
    echo "⚠️  Warp not found, skipping Warp backup"
fi

# Create a restore script
echo "📜 Creating restore script..."
cat > "$DOTFILES_DIR/restore.sh" << 'EOF'
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
EOF

chmod +x "$DOTFILES_DIR/restore.sh"

# Create installation script for new machines
echo "📜 Creating installation script for new machines..."
cat > "$DOTFILES_DIR/install.sh" << 'EOF'
#!/bin/bash

# New Machine Setup Script
# This script sets up a new machine with your dotfiles configuration

set -e

echo "🚀 Setting up new machine with your dotfiles..."

# Install Homebrew (if not installed)
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install essential tools
echo "🛠️  Installing essential tools..."
brew install git curl wget zsh fzf starship

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "⚡ Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    echo "🔍 Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
fi

# Restore dotfiles
echo "📁 Restoring dotfiles..."
./restore.sh

echo "🎉 New machine setup complete!"
echo "💡 Please restart your terminal to apply all changes."
EOF

chmod +x "$DOTFILES_DIR/install.sh"

# Initialize git repository
echo "📦 Initializing git repository..."
cd "$DOTFILES_DIR"
if [ ! -d .git ]; then
    git init
    echo "node_modules/" > .gitignore
    echo "*.log" >> .gitignore
    echo ".DS_Store" >> .gitignore
fi

# Create README
cat > README.md << 'EOF'
# 🔥 My Sexy Dotfiles

This repository contains my terminal and shell configuration that I sync across all my devices.

## 🌟 What's Included

- **Oh My Zsh** with Powerlevel10k theme
- **Starship** prompt configuration  
- **fzf** fuzzy finder setup
- **kubectl** aliases for Kubernetes
- **Custom environment variables** and PATH configurations
- **Warp terminal** settings backup
- **Development tools** configuration (NVM, pnpm, bun, etc.)

## 🚀 Quick Setup on New Machine

```bash
# Clone this repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh
```

## 🔄 Manual Restore

If you just want to restore dotfiles without installing everything:

```bash
cd ~/dotfiles
./restore.sh
```

## 💾 Backup Current Settings

To backup your current settings:

```bash
cd ~/dotfiles
./backup_and_sync.sh
```

## 📁 File Structure

- `backup/` - Your shell configuration files
- `warp/` - Warp terminal settings
- `install.sh` - Complete setup for new machines
- `restore.sh` - Restore dotfiles only
- `backup_and_sync.sh` - Backup current settings

## 🎨 Customizations

### Oh My Zsh + Powerlevel10k
- Beautiful prompt with git status
- Custom history configuration
- Intelligent autocomplete

### Kubectl Aliases
- `k` - kubectl
- `kgp` - get pods
- `kgpa` - get pods all namespaces
- `kex` - exec into pod
- And many more!

### Development Environment
- Python 3.11 as default
- Go, Node.js, Rust toolchains
- Custom paths for various tools

## 🔧 Customization

Edit the files in the `backup/` directory and run `./restore.sh` to apply changes.

EOF

git add .
git commit -m "Initial dotfiles backup - $(date)"

echo ""
echo "🎉 Dotfiles backup complete!"
echo ""
echo "📁 Your configuration is saved in: $DOTFILES_DIR"
echo ""
echo "🔗 Next steps to sync across devices:"
echo "   1. Push to GitHub: cd $DOTFILES_DIR && git remote add origin <your-repo-url> && git push -u origin main"
echo "   2. On other machines: git clone <your-repo-url> ~/dotfiles && cd ~/dotfiles && ./install.sh"
echo ""
echo "🛠️  Available commands:"
echo "   • $DOTFILES_DIR/backup_and_sync.sh - Backup current settings"
echo "   • $DOTFILES_DIR/restore.sh - Restore settings"
echo "   • $DOTFILES_DIR/install.sh - Full setup on new machine"
