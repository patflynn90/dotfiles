# ~/.zshrc
#
# Interactive‐shell initialization: options, prompt, completion, keybindings, aliases, functions.

##
## 1) Shell options & history
##

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY      # add to history, don’t overwrite
setopt SHARE_HISTORY       # share history across sessions
setopt HIST_IGNORE_DUPS    # skip duplicates
setopt HIST_REDUCE_BLANKS  # remove superfluous blanks
setopt HIST_VERIFY         # show before executing history expansions

setopt AUTO_CD             # bare dir name → cd
setopt AUTO_PUSHD          # pushd on cd
setopt PUSHD_SILENT        # no pushd output
setopt PUSHD_TO_HOME       # cd with no args → $HOME

setopt EXTENDED_GLOB       # **, ^, etc.

setopt CORRECT             # auto‐correct command names
# setopt CORRECT_ALL      # auto‐correct all args (optional)

##
## 2) Keybindings style
##

# Vi editing mode (or switch to emacs with bindkey -e)
bindkey -v

##
## 3) Completion system
##

autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:approximate:*' max-errors 1 numeric
compinit -C

##
## 4) Git‐aware prompt via vcs_info
##

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats    ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}%b|%a%f'
precmd() { vcs_info }

setopt PROMPT_SUBST
PROMPT='%F{green}%n:%F{blue}%1~%f${vcs_info_msg_0_} %# '

##
## 5) Optional tooling integrations
##

# fzf
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
fi

# zsh‐syntax‐highlighting
if [ -r /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh‐autosuggestions
if [ -r /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

##
## 6) Aliases & functions
##

# ls
if command -v ls >/dev/null; then
  alias ll='ls -lhG'
  alias la='ls -lAhG'
fi

# grep
if command -v grep >/dev/null; then
  alias grep='grep --color=auto'
fi

# git
if command -v git >/dev/null; then
  alias gs='git status'
  alias ga='git add'
  alias gc='git commit -v'
  alias gp='git push'
  alias gl='git pull'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

# Quick extract function (no external deps)
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar x "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"      ;;
      *.Z)         uncompress "$1" ;;
      *)           echo "extract: '$1' — unknown archive" ;;
    esac
  else
    echo "extract: '$1' not a valid file"
  fi
}

##
## 7) Editor & misc
##

# Prefer nvim if available, else vim
if command -v nvim >/dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi
export VISUAL="$EDITOR"
