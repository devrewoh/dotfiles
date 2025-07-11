# Dotfiles

Personal configuration files managed with [chezmoi](https://chezmoi.io).

## Setup

1. **Install chezmoi:**
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. **Clone and apply dotfiles:**
   ```bash
   chezmoi init --apply https://github.com/devrewoh/dotfiles.git
   ```

3. **Configure personal data:**
   ```bash
   chezmoi edit-config
   ```
   Add your details:
   ```toml
   [data]
       github_username = "Your Name"
       github_email = "your@email.com"
   ```

## Included Configurations

- **Shell:** bash with XDG compliance
- **Terminal:** Alacritty (TOML format)
- **Editor:** Neovim (minimal, Go-focused)
- **Multiplexer:** tmux
- **Git:** Templated for multi-machine use
- **SSH:** Security-focused defaults

## Usage

```bash
# Edit configs
chezmoi edit ~/.gitconfig

# Apply changes
chezmoi apply

# Add new config
chezmoi add ~/.config/newapp/config.toml
```

## Philosophy

Minimal, secure, Go/backend-focused configurations using modern tooling.
