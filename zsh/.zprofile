# ~/.zprofile — Login‐shell setup

# 1) Homebrew (Apple Silicon)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2) User bin directories
for _d in "$HOME/bin" "$HOME/.local/bin"; do
  [[ -d $_d ]] && PATH="$_d:$PATH"
done
export PATH

# 3) pyenv
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT=${PYENV_ROOT:-$HOME/.pyenv}
  PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

# 4) NVM
export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# 5) SDKMAN
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# 6) API keys from macOS keychain
if command -v security &>/dev/null; then
  export ANTHROPIC_API_KEY=$(
    security find-generic-password -a "$USER" -s "ANTHROPIC_API_KEY" -w 2>/dev/null
  )
  export OPENAI_API_KEY=$(
    security find-generic-password -a "$USER" -s "OPENAI_API_KEY" -w 2>/dev/null
  )
fi
