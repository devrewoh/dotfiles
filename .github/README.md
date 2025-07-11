# Dotfiles

Personal configuration files managed with [chezmoi](https://chezmoi.io).

## Setup

1. **Install chezmoi:** See [chezmoi.io](https://chezmoi.io) for installation instructions

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
- **Editors:** Neovim (minimal, Go-focused) + micro
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
