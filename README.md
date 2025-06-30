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

