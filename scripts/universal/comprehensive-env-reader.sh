#!/bin/bash
# Comprehensive Environment Reader - All Systems
# Run this on: Kubuntu, CachyOS, macOS, Debian
# Save as: comprehensive-env-reader.sh

echo "=========================================="
echo "COMPREHENSIVE ENVIRONMENT ANALYSIS"
echo "=========================================="
echo "Timestamp: $(date)"
echo "Hostname: $(hostname)"
echo "User: $USER (UID: $(id -u))"
echo

echo "=== SYSTEM IDENTIFICATION ==="
echo "Kernel: $(uname -srv)"
echo "Architecture: $(uname -m)"
echo "OS Type: $OSTYPE"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS Version: $(sw_vers -productVersion)"
    echo "macOS Build: $(sw_vers -buildVersion)"
    echo "Hardware: $(system_profiler SPHardwareDataType | grep "Model Name" | cut -d: -f2 | xargs)"
elif [[ -f /etc/os-release ]]; then
    echo "Linux Distribution:"
    cat /etc/os-release
    echo
    echo "Kernel Details:"
    uname -a
else
    echo "Unknown system type"
fi

echo
echo "=== SHELL ENVIRONMENT ==="
echo "Current Shell: $SHELL"
echo "Shell Version:"
if [[ "$SHELL" == *"bash"* ]]; then
    echo "Bash: $BASH_VERSION"
elif [[ "$SHELL" == *"zsh"* ]]; then
    zsh --version 2>/dev/null || echo "Zsh version unknown"
elif [[ "$SHELL" == *"fish"* ]]; then
    fish --version 2>/dev/null || echo "Fish version unknown"
fi

echo
echo "Available Shells:"
cat /etc/shells

echo
echo "=== PATH AND ENVIRONMENT VARIABLES ==="
echo "PATH: $PATH"
echo
echo "XDG Base Directory Variables:"
echo "  XDG_CONFIG_HOME: ${XDG_CONFIG_HOME:-'<unset> (default: ~/.config)'}"
echo "  XDG_DATA_HOME: ${XDG_DATA_HOME:-'<unset> (default: ~/.local/share)'}"
echo "  XDG_STATE_HOME: ${XDG_STATE_HOME:-'<unset> (default: ~/.local/state)'}"
echo "  XDG_CACHE_HOME: ${XDG_CACHE_HOME:-'<unset> (default: ~/.cache)'}"
echo "  XDG_RUNTIME_DIR: ${XDG_RUNTIME_DIR:-'<unset>'}"
echo "  XDG_CONFIG_DIRS: ${XDG_CONFIG_DIRS:-'<unset> (default: /etc/xdg)'}"
echo "  XDG_DATA_DIRS: ${XDG_DATA_DIRS:-'<unset> (default: /usr/local/share/:/usr/share/)'}"

echo
echo "XDG Directory Status:"
# Check user-specific directories (resolved to actual paths)
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
BIN_DIR="$HOME/.local/bin"

echo "  Config directory: $CONFIG_DIR $([ -d "$CONFIG_DIR" ] && echo '✓ exists' || echo '✗ missing')"
echo "  Data directory: $DATA_DIR $([ -d "$DATA_DIR" ] && echo '✓ exists' || echo '✗ missing')"
echo "  State directory: $STATE_DIR $([ -d "$STATE_DIR" ] && echo '✓ exists' || echo '✗ missing')"
echo "  Cache directory: $CACHE_DIR $([ -d "$CACHE_DIR" ] && echo '✓ exists' || echo '✗ missing')"
echo "  User bin directory: $BIN_DIR $([ -d "$BIN_DIR" ] && echo '✓ exists' || echo '✗ missing')"

if [[ -n "$XDG_RUNTIME_DIR" ]]; then
    echo "  Runtime directory: $XDG_RUNTIME_DIR $([ -d "$XDG_RUNTIME_DIR" ] && echo '✓ exists' || echo '✗ missing')"
    if [[ -d "$XDG_RUNTIME_DIR" ]]; then
        RUNTIME_PERMS=$(stat -c "%a" "$XDG_RUNTIME_DIR" 2>/dev/null || stat -f "%OLp" "$XDG_RUNTIME_DIR" 2>/dev/null)
        RUNTIME_OWNER=$(stat -c "%U" "$XDG_RUNTIME_DIR" 2>/dev/null || stat -f "%Su" "$XDG_RUNTIME_DIR" 2>/dev/null)
        echo "    Permissions: $RUNTIME_PERMS $([ "$RUNTIME_PERMS" = "700" ] && echo '✓ correct' || echo '⚠ should be 700')"
        echo "    Owner: $RUNTIME_OWNER $([ "$RUNTIME_OWNER" = "$USER" ] && echo '✓ correct' || echo '⚠ should be $USER')"
    fi
else
    echo "  Runtime directory: <unset> ⚠ applications should set this"
fi

echo
echo "XDG System Directories:"
# Check system directories
CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

echo "  System config dirs: $CONFIG_DIRS"
IFS=':' read -ra CONFIG_ARRAY <<< "$CONFIG_DIRS"
for dir in "${CONFIG_ARRAY[@]}"; do
    echo "    $dir $([ -d "$dir" ] && echo '✓ exists' || echo '✗ missing')"
done

echo "  System data dirs: $DATA_DIRS"
IFS=':' read -ra DATA_ARRAY <<< "$DATA_DIRS"
for dir in "${DATA_ARRAY[@]}"; do
    [[ -n "$dir" ]] && echo "    $dir $([ -d "$dir" ] && echo '✓ exists' || echo '✗ missing')"
done

echo
echo "XDG Compliance Check:"
echo "  ~/.local/bin in PATH: $(echo "$PATH" | grep -q "$HOME/.local/bin" && echo '✓ yes' || echo '✗ no - should be added')"

echo
echo "Other Important Variables:"
echo "  HOME: $HOME"
echo "  USER: $USER"
echo "  LANG: ${LANG:-'<unset>'}"
echo "  LC_ALL: ${LC_ALL:-'<unset>'}"
echo "  EDITOR: ${EDITOR:-'<unset>'}"
echo "  VISUAL: ${VISUAL:-'<unset>'}"
echo "  PAGER: ${PAGER:-'<unset>'}"
echo "  TERM: ${TERM:-'<unset>'}"

echo
echo "=== SHELL CONFIGURATION FILES ==="
echo "Checking for shell config files in $HOME:"

# Function to check file existence and size
check_file() {
    if [[ -f "$1" ]]; then
        echo "  ✓ $1 ($(wc -l < "$1") lines, $(stat -f%z "$1" 2>/dev/null || stat -c%s "$1") bytes)"
    elif [[ -L "$1" ]]; then
        echo "  ↗ $1 -> $(readlink "$1") (symlink)"
    else
        echo "  ✗ $1 (not found)"
    fi
}

echo "Bash files:"
check_file "$HOME/.bashrc"
check_file "$HOME/.bash_profile"
check_file "$HOME/.bash_login"
check_file "$HOME/.profile"
check_file "$HOME/.bash_logout"
check_file "$HOME/.bash_history"

echo
echo "Zsh files:"
check_file "$HOME/.zshrc"
check_file "$HOME/.zprofile"
check_file "$HOME/.zshenv"
check_file "$HOME/.zlogin"
check_file "$HOME/.zlogout"
check_file "$HOME/.zsh_history"

echo
echo "Fish files:"
check_file "$HOME/.config/fish/config.fish"
check_file "$HOME/.config/fish/fish_variables"
if [[ -d "$HOME/.config/fish/functions" ]]; then
    echo "  ✓ $HOME/.config/fish/functions/ ($(ls "$HOME/.config/fish/functions" | wc -l) files)"
else
    echo "  ✗ $HOME/.config/fish/functions/ (not found)"
fi

echo
echo "Generic profile files:"
check_file "$HOME/.profile"
check_file "/etc/profile"
check_file "/etc/bash.bashrc"
check_file "/etc/zsh/zshrc"

echo
echo "=== SHELL INITIALIZATION & SOURCE FILES ==="
echo "System-wide shell initialization:"
check_file "/etc/profile"
check_file "/etc/bash.bashrc"
check_file "/etc/zsh/zshrc"
check_file "/etc/fish/config.fish"
check_file "/etc/environment"

echo
echo "User shell initialization order and sourcing:"
echo "Login shell process (typical order):"
echo "  1. /etc/profile"
echo "  2. ~/.bash_profile OR ~/.bash_login OR ~/.profile (first found)"
echo "  3. ~/.bashrc (if sourced by profile)"

echo
echo "Checking actual source statements:"
for file in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile" "$HOME/.zshrc" "$HOME/.config/fish/config.fish"; do
    if [[ -f "$file" ]]; then
        echo "Sources in $file:"
        grep -n "source\|^\." "$file" 2>/dev/null | head -3 || echo "  No source statements found"
    fi
done

echo
echo "=== PACKAGE MANAGERS ==="
echo "Checking available package managers:"

check_pm() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "  ✓ $1: $($1 --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $1: not found"
    fi
}

check_pm "apt"
check_pm "pacman"
check_pm "yay"
check_pm "paru"
check_pm "brew"
check_pm "snap"
check_pm "flatpak"
check_pm "dnf"
check_pm "zypper"

echo
echo "=== VERSION MANAGERS & RUNTIME TOOLS ==="
echo "ASDF (unified version manager):"
check_file "$HOME/.asdf"
if [[ -d "$HOME/.asdf" ]]; then
    echo "    ASDF version: $(cat "$HOME/.asdf/VERSION" 2>/dev/null || echo 'unknown')"
    echo "    Installed plugins: $(ls "$HOME/.asdf/plugins" 2>/dev/null | tr '\n' ' ' || echo 'none')"
    echo "    Global versions:"
    cat "$HOME/.tool-versions" 2>/dev/null | head -5 || echo "    No .tool-versions file"
fi

echo
echo "Other version managers:"
check_file "$HOME/.nvm"
if [[ -d "$HOME/.nvm" ]]; then
    echo "    NVM version: $(cat "$HOME/.nvm/VERSION" 2>/dev/null || echo 'unknown')"
fi
check_file "$HOME/.pyenv"
check_file "$HOME/.rbenv"
check_file "$HOME/.goenv"
check_file "$HOME/.cargo"
if [[ -d "$HOME/.cargo" ]]; then
    echo "    Cargo/Rust toolchain detected"
fi

echo
echo "=== DEVELOPMENT LANGUAGES & TOOLS ==="
echo "Core development tools:"
for tool in git gh python3 node npm yarn pip3 go rust cargo java javac python2 ruby lua; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Network and HTTP tools:"
for tool in curl wget httpie; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "JSON and data processing:"
for tool in jq yq; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "File and text utilities:"
for tool in tree ripgrep fd bat exa eza fzf; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done
# Check for fd-find (Ubuntu naming)
if command -v fdfind >/dev/null 2>&1; then
    echo "  ✓ fdfind: $(command -v fdfind) - $(fdfind --version 2>/dev/null | head -1 || echo 'version unknown')"
fi

echo
echo "Build tools and compilers:"
for tool in make cmake gcc clang; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "=== EDITORS & TEXT TOOLS ==="
echo "Text editors:"
for tool in vim nvim nano emacs micro code; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Editor configurations:"
check_file "$HOME/.vimrc"
check_file "$HOME/.config/nvim/init.lua"
check_file "$HOME/.config/nvim/init.vim"
if [[ -d "$HOME/.config/nvim" ]]; then
    echo "  ✓ Neovim config dir exists ($(find "$HOME/.config/nvim" -name "*.lua" -o -name "*.vim" | wc -l) config files)"
fi

echo
echo "=== TERMINAL & MULTIPLEXERS ==="
echo "Terminal multiplexers:"
for tool in tmux screen zellij; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool -V 2>/dev/null || $tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Terminal configurations:"
check_file "$HOME/.tmux.conf"
check_file "$HOME/.config/tmux/tmux.conf"
check_file "$HOME/.screenrc"

echo
echo "Terminal emulators:"
for tool in alacritty kitty wezterm; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Terminal emulator configs:"
check_file "$HOME/.config/alacritty/alacritty.yml"
check_file "$HOME/.config/alacritty/alacritty.toml"
check_file "$HOME/.config/kitty/kitty.conf"
check_file "$HOME/.config/wezterm/wezterm.lua"

echo
echo "=== WEB BROWSERS ==="
echo "Firefox installations:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ -d "/Applications/Firefox.app" ]]; then
        echo "  ✓ Firefox.app: $(defaults read /Applications/Firefox.app/Contents/Info CFBundleShortVersionString 2>/dev/null || echo 'version unknown')"
    else
        echo "  ✗ Firefox.app: not found"
    fi
    if [[ -d "/Applications/Firefox Developer Edition.app" ]]; then
        echo "  ✓ Firefox Developer Edition.app: $(defaults read "/Applications/Firefox Developer Edition.app/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo 'version unknown')"
    else
        echo "  ✗ Firefox Developer Edition.app: not found"
    fi
else
    for firefox in firefox firefox-developer-edition firefox-dev firefox-esr; do
        if command -v "$firefox" >/dev/null 2>&1; then
            echo "  ✓ $firefox: $(command -v "$firefox") - $($firefox --version 2>/dev/null || echo 'version unknown')"
        else
            echo "  ✗ $firefox: not found"
        fi
    done

    # Check for snap/flatpak installations
    if command -v snap >/dev/null 2>&1; then
        if snap list 2>/dev/null | grep -q firefox; then
            echo "  ✓ Firefox (snap)"
        else
            echo "  ✗ Firefox (snap): not found"
        fi
    fi
    if command -v flatpak >/dev/null 2>&1; then
        if flatpak list 2>/dev/null | grep -q firefox; then
            echo "  ✓ Firefox (flatpak)"
        else
            echo "  ✗ Firefox (flatpak): not found"
        fi
    fi
fi

echo
echo "Firefox profiles and config:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    FIREFOX_PROFILE_DIR="$HOME/Library/Application Support/Firefox"
else
    FIREFOX_PROFILE_DIR="$HOME/.mozilla/firefox"
fi

if [[ -d "$FIREFOX_PROFILE_DIR" ]]; then
    echo "  ✓ Firefox profile directory: $FIREFOX_PROFILE_DIR"
    echo "  Profiles: $(ls "$FIREFOX_PROFILE_DIR" | grep -v "profiles.ini" | wc -l || echo 0)"
    if [[ -f "$FIREFOX_PROFILE_DIR/profiles.ini" ]]; then
        echo "  ✓ profiles.ini exists"
    fi
else
    echo "  ✗ No Firefox profile directory found"
fi

echo
echo "Other browsers:"
for browser in chrome chromium safari edge; do
    if command -v "$browser" >/dev/null 2>&1; then
        echo "  ✓ $browser: $(command -v "$browser")"
    else
        echo "  ✗ $browser: not found"
    fi
done

echo
echo "=== DOTFILES MANAGEMENT ==="
echo "Chezmoi (dotfiles manager):"
if command -v chezmoi >/dev/null 2>&1; then
    echo "  ✓ chezmoi: $(chezmoi --version)"
    echo "  Source dir: $(chezmoi source-path 2>/dev/null || echo 'not initialized')"
    echo "  Config file: $(chezmoi doctor 2>/dev/null | grep "config file" | cut -d: -f2 | xargs || echo 'not found')"
else
    echo "  ✗ chezmoi not found"
fi

if [[ -d "$HOME/.local/share/chezmoi" ]]; then
    echo "  ✓ chezmoi source directory exists ($(find "$HOME/.local/share/chezmoi" -type f | wc -l) files)"
    if [[ -f "$HOME/.local/share/chezmoi/.chezmoi.toml.tmpl" ]] || [[ -f "$HOME/.local/share/chezmoi/.chezmoi.yaml.tmpl" ]]; then
        echo "  ✓ chezmoi config template found"
    fi
fi

check_file "$HOME/.config/chezmoi/chezmoi.toml"
check_file "$HOME/.config/chezmoi/chezmoi.yaml"

echo
echo "Other dotfiles tools:"
for tool in stow rcm yadm; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool")"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "=== GIT & GITHUB ==="
echo "Git configuration:"
if command -v git >/dev/null 2>&1; then
    echo "  Git version: $(git --version)"
    echo "  User name: $(git config --global user.name 2>/dev/null || echo 'not set')"
    echo "  User email: $(git config --global user.email 2>/dev/null || echo 'not set')"
    echo "  Default branch: $(git config --global init.defaultBranch 2>/dev/null || echo 'not set')"
    echo "  Core editor: $(git config --global core.editor 2>/dev/null || echo 'not set')"
fi

check_file "$HOME/.gitconfig"
check_file "$HOME/.gitignore_global"
check_file "$HOME/.config/git/config"

echo
echo "GitHub CLI:"
if command -v gh >/dev/null 2>&1; then
    echo "  ✓ gh: $(gh --version | head -1)"
    echo "  Auth status: $(gh auth status 2>&1 | grep "Logged in" || echo 'not authenticated')"
else
    echo "  ✗ gh: not found"
fi

check_file "$HOME/.config/gh/config.yml"

echo
echo "SSH configuration:"
check_file "$HOME/.ssh/config"
if [[ -d "$HOME/.ssh" ]]; then
    echo "  SSH keys: $(ls "$HOME/.ssh"/*.pub 2>/dev/null | wc -l || echo 0) public keys found"
fi

echo
echo "=== API & DEVELOPMENT TOOLS ==="
echo "API testing tools:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ -d "/Applications/Postman.app" ]]; then
        echo "  ✓ Postman.app: found in Applications"
    else
        echo "  ✗ Postman.app: not found"
    fi
    if [[ -d "/Applications/Insomnia.app" ]]; then
        echo "  ✓ Insomnia.app: found in Applications"
    else
        echo "  ✗ Insomnia.app: not found"
    fi
else
    for tool in postman insomnia; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "  ✓ $tool: $(command -v "$tool")"
        else
            echo "  ✗ $tool: not found"
        fi
    done

    # Check for snap/flatpak installations
    if command -v snap >/dev/null 2>&1; then
        if snap list 2>/dev/null | grep -q -E "(postman|insomnia)"; then
            snap list 2>/dev/null | grep -E "(postman|insomnia)" | while read line; do
                echo "  ✓ $(echo "$line" | awk '{print $1}') (snap)"
            done
        fi
    fi
    if command -v flatpak >/dev/null 2>&1; then
        if flatpak list 2>/dev/null | grep -q -E "(postman|insomnia)"; then
            flatpak list 2>/dev/null | grep -E "(postman|insomnia)" | while read line; do
                echo "  ✓ $(echo "$line" | cut -d$'\t' -f1) (flatpak)"
            done
        fi
    fi
fi

echo
echo "=== DOCUMENTATION & HELP ==="
echo "Documentation tools:"
for tool in man tldr tealdeer; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Manual pages:"
if command -v man >/dev/null 2>&1; then
    MANPATH_INFO=$(manpath 2>/dev/null || echo "manpath command not available")
    echo "  Man path: $MANPATH_INFO"

    # Count man pages in common sections
    if [[ -d "/usr/share/man" ]]; then
        MAN_COUNT=$(find /usr/share/man -name "*.gz" -o -name "*.[1-9]" 2>/dev/null | wc -l)
        echo "  System man pages: ~$MAN_COUNT"
    fi
else
    echo "  ✗ man: not available"
fi

echo
echo "Help databases:"
if [[ -d "/usr/share/doc" ]]; then
    DOC_COUNT=$(ls /usr/share/doc 2>/dev/null | wc -l)
    echo "  System documentation: $DOC_COUNT packages in /usr/share/doc"
fi

if command -v info >/dev/null 2>&1; then
    echo "  ✓ info: $(command -v info) (GNU info system)"
else
    echo "  ✗ info: not found"
fi

echo
echo "=== FONTS & APPEARANCE ==="
echo "Font directories:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  System fonts: $(ls /System/Library/Fonts/*.ttf /System/Library/Fonts/*.otf 2>/dev/null | wc -l || echo 0)"
    echo "  User fonts: $(ls "$HOME/Library/Fonts"/*.ttf "$HOME/Library/Fonts"/*.otf 2>/dev/null | wc -l || echo 0)"
else
    echo "  System fonts: $(fc-list | wc -l || echo 'fc-list not available')"
    if [[ -d "$HOME/.local/share/fonts" ]]; then
        echo "  ✓ User fonts directory: $(ls "$HOME/.local/share/fonts" | wc -l) items"
    else
        echo "  ✗ User fonts directory not found"
    fi
fi

echo
echo "Nerd Fonts (for terminal/editor icons):"
if command -v fc-list >/dev/null 2>&1; then
    NERD_FONTS=$(fc-list | grep -i "nerd\|powerline\|fira code\|jetbrains mono\|hack" | wc -l)
    echo "  Potential nerd fonts found: $NERD_FONTS"
else
    echo "  Cannot check fonts (fc-list not available)"
fi

echo
echo "=== CLOUD & SYNC TOOLS ==="
echo "Cloud storage and sync:"
for tool in dropbox gdrive rclone rsync; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool")"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "=== SECURITY & GPG ==="
echo "GPG/encryption tools:"
for tool in gpg gpg2 pass; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

if command -v gpg >/dev/null 2>&1; then
    GPG_KEYS=$(gpg --list-secret-keys 2>/dev/null | grep -c "sec " || echo 0)
    echo "  GPG secret keys: $GPG_KEYS"
fi

echo
echo "=== CONTAINER & VIRTUALIZATION ==="
echo "Container tools:"
for tool in docker podman docker-compose; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool") - $($tool --version 2>/dev/null | head -1 || echo 'version unknown')"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "Virtualization:"
for tool in vagrant vbox virtualbox qemu; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool")"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "=== SYSTEM MONITORING & INFO ==="
echo "System information tools:"
for tool in htop btop neofetch fastfetch; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool: $(command -v "$tool")"
    else
        echo "  ✗ $tool: not found"
    fi
done

echo
echo "=== DOTFILES AND CONFIG DIRECTORIES ==="
echo "Home directory dotfiles:"
ls -la "$HOME" | grep "^\." | head -10
echo "  ... (showing first 10)"

echo
echo "Config directories:"
if [[ -d "$HOME/.config" ]]; then
    echo "  ✓ ~/.config/ ($(ls "$HOME/.config" | wc -l) items)"
    echo "    Contents: $(ls "$HOME/.config" | head -5 | tr '\n' ' ')..."
else
    echo "  ✗ ~/.config/ not found"
fi

if [[ -d "$HOME/.local" ]]; then
    echo "  ✓ ~/.local/ exists"
    echo "    bin/: $(ls "$HOME/.local/bin" 2>/dev/null | wc -l || echo 0) items"
    echo "    share/: $(ls "$HOME/.local/share" 2>/dev/null | wc -l || echo 0) items"
else
    echo "  ✗ ~/.local/ not found"
fi

echo
echo "=== SYMLINKS IN HOME ==="
echo "Symlinks in home directory:"
find "$HOME" -maxdepth 1 -type l -exec ls -la {} \; 2>/dev/null | head -5

echo
echo "=== SHARED STORAGE STATUS ==="
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS Volumes:"
    ls -la /Volumes/ 2>/dev/null || echo "Cannot access /Volumes"
else
    echo "Linux mount points:"
    df -h | grep -E "(mnt|media)" || echo "No additional mounts found"

    echo
    echo "Shared drive access test:"
    for mount in /mnt/shared /mnt/bulk /mnt/linuxbackup; do
        if [[ -d "$mount" ]]; then
            if [[ -w "$mount" ]]; then
                echo "  ✓ $mount (writable)"
            else
                echo "  ! $mount (exists but not writable)"
            fi
        else
            echo "  ✗ $mount (not found)"
        fi
    done
fi

echo
echo "=== INIT SYSTEM ==="
if command -v systemctl >/dev/null 2>&1; then
    echo "  ✓ systemd detected"
elif [[ -f /sbin/init ]] && [[ -L /sbin/init ]]; then
    echo "  Init system: $(readlink /sbin/init)"
else
    echo "  Unknown init system"
fi

echo
echo "=== NETWORK CONFIGURATION ==="
echo "Hostname resolution:"
echo "  /etc/hosts entries: $(grep -v '^#' /etc/hosts 2>/dev/null | wc -l || echo 'unknown')"
echo "  DNS servers: $(cat /etc/resolv.conf 2>/dev/null | grep nameserver | wc -l || echo 'unknown')"

echo
echo "=========================================="
echo "ANALYSIS COMPLETE FOR $(hostname)"
echo "=========================================="
