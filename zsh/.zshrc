# ~/.zshrc — Interactive‐shell setup
# Bail out if not interactive
[[ $- != *i* ]] && return

# 1) History & options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_REDUCE_BLANKS HIST_VERIFY
setopt AUTO_CD AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt EXTENDED_GLOB CORRECT

# 2) Editing mode
bindkey -v    # vi-mode; switch to emacs with 'bindkey -e'

# 3) Completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:approximate:*' max-errors 1 numeric
compinit -C

# 4) Git‐aware prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{red}%b|%a%f'
precmd() { vcs_info }
setopt PROMPT_SUBST
PROMPT='%F{green}%n:%F{blue}%1~%f${vcs_info_msg_0_} %# '

# 5) Tool integrations
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# zsh-syntax-highlighting
for _f in \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  [[ -r $_f ]] && source "$_f" && break
done

# zsh-autosuggestions
for _f in \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  [[ -r $_f ]] && source "$_f" && break
done

# 6) Aliases & functions

# Prefer eza if available
if command -v eza &>/dev/null; then
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -la --git --group-directories-first --icons'
else
  alias ll='ls -lhG'
  alias la='ls -lAhG'
fi

command -v grep &>/dev/null && alias grep='grep --color=auto'

if command -v git &>/dev/null; then
  alias gs='git status'
  alias ga='git add'
  alias gc='git commit -v'
  alias gp='git push'
  alias gl='git pull'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'

# extract: unpack various archives
extract() {
  local file=$1
  if [[ ! -f $file ]]; then
    echo "extract: '$file' not a valid file" >&2
    return 1
  fi
  case $file in
    *.tar.bz2)   tar xjf "$file" ;;
    *.tar.gz|*.tgz) tar xzf "$file" ;;
    *.tar.xz)    tar xJf "$file" ;;
    *.tbz2)      tar xjf "$file" ;;
    *.zip)       unzip "$file" ;;
    *.rar)       unrar x "$file" ;;
    *.gz)        gunzip "$file" ;;
    *.bz2)       bunzip2 "$file" ;;
    *.Z)         uncompress "$file" ;;
    *)           echo "extract: '$file' — unknown archive" >&2; return 1 ;;
  esac
}

# pbcat: cat files or stdin into macOS clipboard
pbcat() {
  if (( $# )); then
    cat -- "$@" | pbcopy
  else
    pbcopy
  fi
}

# 7) Editor
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR

# 8) Perl local::lib
export PATH="$HOME/.perl5/bin:${PATH}"
export PERL5LIB="$HOME/.perl5/lib/perl5${PERL5LIB:+:}$PERL5LIB"
export PERL_LOCAL_LIB_ROOT="$HOME/.perl5${PERL_LOCAL_LIB_ROOT:+:}$PERL_LOCAL_LIB_ROOT"
export PERL_MB_OPT="--install_base=$HOME/.perl5"
export PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5"
