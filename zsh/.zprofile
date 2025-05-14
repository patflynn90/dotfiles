# ~/.zprofile
#
# Login‐shell initialization: environment variables, PATH, language tools, brew.

# 1) Homebrew environment (macOS on Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2) User‐local bin directories
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
export PATH

# 3) pyenv (if installed)
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

# 4) nvm (Node Version Manager)
if [ -d "${NVM_DIR:-$HOME/.nvm}" ]; then
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 5) SDKMAN (if installed)
if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# any other login‐only exports go here
export ANTHROPIC_API_KEY=$(security find-generic-password -a $USER -s "ANTHROPIC_API_KEY" -w)
export OPENAI_API_KEY=$(security find-generic-password -a $USER -s "OPENAI_API_KEY" -w)
