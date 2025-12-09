#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Install Homebrew (macOS) or Linuxbrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for this session
        if [[ "$OS" == "macos" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    else
        echo "Homebrew already installed"
    fi
}

# Install packages from Brewfile
install_packages() {
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
}

# Install Oh My Zsh
install_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh already installed"
    fi
}

# Install zsh plugins
install_zsh_plugins() {
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"

    echo "Installing zsh plugins..."

    # zsh-autosuggestions
    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
    fi

    # zsh-completions
    if [ ! -d "$plugins_dir/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"
    fi

    # zsh-history-substring-search
    if [ ! -d "$plugins_dir/zsh-history-substring-search" ]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search "$plugins_dir/zsh-history-substring-search"
    fi
}

# Create symlinks
create_symlinks() {
    echo "Creating symlinks..."

    # Backup existing files
    backup_if_exists() {
        if [ -f "$1" ] && [ ! -L "$1" ]; then
            echo "Backing up $1 to $1.backup"
            mv "$1" "$1.backup"
        fi
    }

    # Zsh
    backup_if_exists "$HOME/.zshrc"
    backup_if_exists "$HOME/.zprofile"
    ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"

    # Git
    backup_if_exists "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

    # Starship
    mkdir -p "$HOME/.config"
    backup_if_exists "$HOME/.config/starship.toml"
    ln -sf "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"
}

# Main installation
main() {
    echo "=== Dotfiles Installation ==="
    echo "OS detected: $OS"
    echo ""

    install_homebrew
    install_packages
    install_omz
    install_zsh_plugins
    create_symlinks

    echo ""
    echo "=== Installation Complete ==="
    echo "Please restart your terminal or run: source ~/.zshrc"
}

main "$@"
