# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Add shell type check for compatibility when sourced from non-zsh shells
if [ -n "$ZSH_VERSION" ]; then
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
if [ -n "$ZSH_VERSION" ]; then
  export ZSH="$HOME/.oh-my-zsh"

  # Set name of the theme to load --- if set to "random", it will
  # load a random theme each time Oh My Zsh is loaded, in which case,
  # to know which specific one was loaded, run: echo $RANDOM_THEME
  # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
  ZSH_THEME="powerlevel10k/powerlevel10k"

  # Set list of themes to pick from when loading at random
  # Setting this variable when ZSH_THEME=random will cause zsh to load
  # a theme from this variable instead of looking in $ZSH/themes/
  # If set to an empty array, this variable will have no effect.
  # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

  # Uncomment the following line to use case-sensitive completion.
  # CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion.
  # Case-sensitive completion must be off. _ and - will be interchangeable.
  # HYPHEN_INSENSITIVE="true"

  # Uncomment one of the following lines to change the auto-update behavior
  # zstyle ':omz:update' mode disabled  # disable automatic updates
  # zstyle ':omz:update' mode auto      # update automatically without asking
  # zstyle ':omz:update' mode reminder  # just remind me to update when it's time

  # Uncomment the following line to change how often to auto-update (in days).
  # zstyle ':omz:update' frequency 13

  # Uncomment the following line if pasting URLs and other text is messed up.
  # DISABLE_MAGIC_FUNCTIONS="true"

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  # You can also set it to another string to have that shown instead of the default red dots.
  # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
  # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
  # COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
  # under VCS as dirty. This makes repository status check for large repositories
  # much, much faster.
  # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Uncomment the following line if you want to change the command execution time
  # stamp shown in the history command output.
  # You can set one of the optional three formats:
  # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
  # or set a custom format using the strftime function format specifications,
  # see 'man strftime' for details.
  # HIST_STAMPS="mm/dd/yyyy"

  # Would you like to use another custom folder than $ZSH/custom?
  # ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load?
  # Standard plugins can be found in $ZSH/plugins/
  # Custom plugins may be added to $ZSH_CUSTOM/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(git)

  source $ZSH/oh-my-zsh.sh
fi

# History and Autocomplete Configuration
# These settings prioritize recent commands in history search and autocomplete
if [ -n "$ZSH_VERSION" ]; then
  # Remove older duplicate commands from history
  HIST_IGNORE_ALL_DUPS=true
  
  # Avoid showing duplicates in history search
  setopt HIST_FIND_NO_DUPS
  
  # Expire duplicate entries first when trimming history
  setopt HIST_EXPIRE_DUPS_FIRST
  
  # Make history search match at beginning of line
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
  
  # Configure completion system to prefer newer matches
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':completion:*:*:*:*:*' menu select
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  
  # Sort completion suggestions by time accessed, newest first
  zstyle ':completion:*' file-sort modification reverse
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Kubectl aliases
alias k='kubectl'
alias kgp='kubectl get pods -n'
alias kgpa='kubectl get pods --all-namespaces'
alias kgn='kubectl get nodes'
alias kgs='kubectl get services'
alias kex='kubectl exec -it -n'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias kcontext='kubectl config current-context'

# Note: Using both starship and powerlevel10k is redundant
# You may want to choose one or the other in the future
if [ -n "$ZSH_VERSION" ]; then
  eval "$(starship init zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Add shell type check for compatibility
if [ -n "$ZSH_VERSION" ]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi


# Source fzf configuration with shell type check
if [ -n "$ZSH_VERSION" ]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# NVM configuration
export NVM_DIR="$HOME/.nvm"
# NVM is compatible with both bash and zsh
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"  # This loads nvm
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
# Add Python user bin directory to PATH
export PATH="$PATH:/Users/arnab/Library/Python/3.9/bin"

# EMA Dev code root directory
export EMA_DEV_CODE_ROOT_DIR=/Users/arnab/code

export EMA_DEV_CODE_ROOT_DIR=/Users/arnab/code

. "$HOME/.local/bin/env"
export PATH=$PATH:$HOME/go/bin

# pnpm
export PNPM_HOME="/Users/arnab/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/arnab/.bun/_bun" ] && source "/Users/arnab/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export GOPRIVATE="github.com/Ema-Unlimited"

# Set Python 3.11 as default
alias python="python3.11"
alias python3="python3.11"

# Source environment variables (create ~/.env with your secrets)
[ -f ~/.env ] && source ~/.env

alias vscode="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
