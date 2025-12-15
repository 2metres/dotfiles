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

# Initialize Sheldon and lock plugins
setup_sheldon() {
    echo "Setting up Sheldon plugin manager..."

    # Create sheldon config directory
    mkdir -p "$HOME/.config/sheldon"

    # Link sheldon config
    ln -sf "$DOTFILES_DIR/config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"

    # Lock plugins (downloads and caches them)
    if command -v sheldon &> /dev/null; then
        echo "Locking Sheldon plugins..."
        sheldon lock
    else
        echo "Warning: sheldon not found. Run 'brew install sheldon' first."
    fi

    # Prompt for name
    read -p "Enter your full name for Git commits: " git_name
    while [[ -z "$git_name" ]]; do
        echo "Name cannot be empty."
        read -p "Enter your full name for Git commits: " git_name
    done

    # Prompt for email
    read -p "Enter your email for Git commits: " git_email
    while [[ -z "$git_email" || ! "$git_email" =~ ^[^@]+@[^@]+\.[^@]+$ ]]; do
        echo "Please enter a valid email address."
        read -p "Enter your email for Git commits: " git_email
    done

    # Update gitconfig file with user info
    sed -i.bak "s/<your_name>/$git_name/" "$DOTFILES_DIR/git/gitconfig"
    sed -i.bak "s/<your_email>/$git_email/" "$DOTFILES_DIR/git/gitconfig"
    rm -f "$DOTFILES_DIR/git/gitconfig.bak"

    echo ""
    echo "Git configured with:"
    echo "  Name:  $git_name"
    echo "  Email: $git_email"
}

# Prompt for user info and configure git
configure_git_user() {
    echo "Configuring Git user information..."
    echo ""

    # Check if already configured
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        echo "Current Git config:"
        echo "  Name:  $current_name"
        echo "  Email: $current_email"
        echo ""
        read -p "Keep existing configuration? [Y/n] " keep_config
        if [[ "$keep_config" =~ ^[Yy]?$ ]]; then
            return
        fi
    fi

    # Prompt for name
    read -p "Enter your full name for Git commits: " git_name
    while [[ -z "$git_name" ]]; do
        echo "Name cannot be empty."
        read -p "Enter your full name for Git commits: " git_name
    done

    # Prompt for email
    read -p "Enter your email for Git commits: " git_email
    while [[ -z "$git_email" || ! "$git_email" =~ ^[^@]+@[^@]+\.[^@]+$ ]]; do
        echo "Please enter a valid email address."
        read -p "Enter your email for Git commits: " git_email
    done

    # Update gitconfig file with user info
    sed -i.bak "s/<your_name>/$git_name/" "$DOTFILES_DIR/git/gitconfig"
    sed -i.bak "s/<your_email>/$git_email/" "$DOTFILES_DIR/git/gitconfig"
    rm -f "$DOTFILES_DIR/git/gitconfig.bak"

    echo ""
    echo "Git configured with:"
    echo "  Name:  $git_name"
    echo "  Email: $git_email"
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

    configure_git_user
    install_homebrew
    install_packages
    create_symlinks
    setup_sheldon

    echo ""
    echo "=== Installation Complete ==="
    echo "Restart your shell with:"
    echo -e "\033[34m  exec zsh\033[0m"
}

main "$@"
