# dotfiles

Cross-platform shell configuration managed with [chezmoi](https://chezmoi.io/).

## System Configuration

### Ubuntu (Bash)
- **Shell**: bash
- **Login shell config**: `~/.profile.linux`
  - Sources `~/.bashrc` for interactive shells
  - Sources custom configurations from `~/.config/shell/`
- **Interactive shell**: `~/.bashrc` (system default, unmodified)

### macOS (Zsh)  
- **Shell**: zsh
- **Login shell config**: `~/.profile.darwin` (minimal)
- **Login shell loader**: `~/.zprofile`
  - Sources custom configurations from `~/.config/shell/`
- **Interactive shell**: `~/.zshrc` (minimal with basic colors)

## Shared Configuration

Located in `~/.config/shell/`:

- **`env`** - XDG Base Directory variables and directory creation
- **`exports`** - Environment variables (EDITOR, BROWSER, TERMINAL)
- **`path`** - Cross-platform PATH management (unified for both systems)
- **`aliases`** - Custom shell aliases (empty, ready for additions)
- **`functions`** - Custom shell functions (empty, ready for additions)

## Shell Loading Sequence

### Ubuntu
1. Login shell sources `~/.profile.linux`
2. `~/.profile.linux` sources `~/.bashrc` 
3. `~/.profile.linux` sources `~/.config/shell/*`
4. Interactive shells get the configuration via `~/.bashrc`

### macOS
1. Login shell sources `~/.zprofile`
2. `~/.zprofile` sources `~/.config/shell/*`
3. Interactive shells source `~/.zshrc` (minimal)

## Key Features

- **XDG Compliant**: Configurations follow XDG Base Directory specification
- **Unified PATH**: Single `path` file handles both macOS (with MacPorts) and Ubuntu
- **Package Manager Aware**: 
  - Ubuntu: apt + snap packages
  - macOS: MacPorts packages
- **Clean Separation**: OS-specific files use `.linux`/`.darwin` extensions

## Tool Configurations

- **alacritty**: Terminal emulator with theme support
- **micro**: Text editor with custom bindings
- **Shell**: Cross-platform environment setup

## Usage

```bash
# Apply configurations
chezmoi apply

# Update from repository  
chezmoi update

# Add new configuration file
chezmoi add ~/.config/newapp/config
```
