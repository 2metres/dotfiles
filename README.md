# Dotfiles

Personal dotfiles for macOS/Linux development environment.

## What's Included

- **Zsh** configuration with [Sheldon](https://sheldon.cli.rs) plugin manager
- **Starship** prompt configuration
- **Git** configuration with delta diff viewer
- **Brewfile** for package management

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
exec zsh
```

## Manual Installation

1. Install Homebrew
2. Run `brew bundle` to install packages
3. Symlink configs:
   ```bash
   ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
   ln -sf ~/dotfiles/zsh/zprofile ~/.zprofile
   ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
   mkdir -p ~/.config/sheldon
   ln -sf ~/dotfiles/config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
   ln -sf ~/dotfiles/config/starship/starship.toml ~/.config/starship.toml
   ```
4. Lock Sheldon plugins: `sheldon lock`

## Plugins

Managed by Sheldon with deferred loading for fast startup:

| Plugin | Purpose |
|--------|---------|
| zsh-defer | Deferred plugin loading |
| zsh-completions | Additional completions |
| zsh-autosuggestions | Fish-like suggestions |
| zsh-history-substring-search | History search with arrows |
| zsh-syntax-highlighting | Command syntax highlighting |

## Key Tools

| Tool | Purpose |
|------|---------|
| sheldon | Fast, configurable plugin manager |
| starship | Fast, customizable prompt |
| fnm | Fast Node Version Manager |
| bat | Better `cat` with syntax highlighting |
| fzf | Fuzzy finder |
| delta | Better git diffs |
| colima | Lightweight Docker runtime |
| claude-code | Anthropic's Claude CLI |

## Git Aliases

```
ga   = git add
gc   = git commit -v
gco  = git checkout
gp   = git push
gpr  = git pull --rebase
grbc = git rebase --continue
gs   = git status
gll  = git log --graph --pretty=oneline --abbrev-commit
```

## Customization

- Modify `zsh/zshrc` for shell config
- Modify `config/sheldon/plugins.toml` for plugins
- Modify `config/starship/starship.toml` for prompt
- Add packages to `Brewfile`
