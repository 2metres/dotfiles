# Dotfiles

Personal dotfiles for macOS/Linux development environment.

## What's Included

- **Zsh** configuration with Oh My Zsh
- **Starship** prompt configuration
- **Git** configuration with delta diff viewer
- **Brewfile** for package management

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Manual Installation

1. Install Homebrew
2. Run `brew bundle` to install packages
3. Install Oh My Zsh
4. Clone zsh plugins to `~/.oh-my-zsh/custom/plugins/`
5. Symlink configs:
   ```bash
   ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
   ln -sf ~/dotfiles/zsh/zprofile ~/.zprofile
   ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
   ln -sf ~/dotfiles/config/starship/starship.toml ~/.config/starship.toml
   ```

## Key Tools

| Tool | Purpose |
|------|---------|
| starship | Fast, customizable prompt |
| fnm | Fast Node Version Manager |
| bat | Better `cat` with syntax highlighting |
| fzf | Fuzzy finder |
| delta | Better git diffs |
| colima | Lightweight Docker runtime |
| claude-code | Anthropic's Claude CLI |

## Customization

- Modify `zsh/zshrc` for shell config
- Modify `config/starship/starship.toml` for prompt
- Add packages to `Brewfile`
