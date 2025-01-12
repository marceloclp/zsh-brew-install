() {
  # @usage   is_installed <command_name>
  # @example is_installed bun
  function is_installed() {
    command -v "$1" >/dev/null 2>&1
  }

  # Checks if a directory exists:
  # @usage   is_dir <path>
  # @example is_dir $HOME/.bun
  function is_dir() {
    [[ -d "$1" ]]
  }

  # Checks if the current operating system is WSL:
  function is_wsl() {
    uname -a | grep -i WSL >/dev/null 2>&1
  }

  # @see https://docs.brew.sh/Homebrew-on-Linux
  function install_brew_wsl() {
    # Brew may be installed in one of these two locations on WSL:
    local dir_global="/home/linuxbrew/.linuxbrew"
    local dir_user="$HOME/.linuxbrew"

    if ! [[ -d $dir_global ]] && ! [[ -d $dir_user ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [[ -d $dir_global ]]; then
      eval "$($dir_global/bin/brew shellenv)"
    elif [[ -d $dir_user ]]; then
      eval "$($dir_user/bin/brew shellenv)"
    else
      echo "(zsh-brew-install) Failed to install brew"
    fi
  }

  function load_brew() {
    eval "$($(brew --prefix)/bin/brew shellenv)"
  }

  if is_installed brew; then
    load_brew
  elif is_wsl; then
    install_brew_wsl
  fi
}
