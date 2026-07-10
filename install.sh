#!/usr/bin/env bash
# install.sh — Oh My Posh setup for Toolbx / container environments
# Usage: bash install.sh

set -euo pipefail

THEME_NAME="tonybaloney-mod.omp.json"
THEME_DIR="$HOME/.poshthemes"
THEME_PATH="$THEME_DIR/$THEME_NAME"
RAW_BASE="https://raw.githubusercontent.com/rouri404/oh-my-posh-toolbx/main"
THEME_URL="$RAW_BASE/$THEME_NAME"
TOTAL_STEPS=5

step() {
    echo "[Step $1/$TOTAL_STEPS] $2"
}

info()    { echo "  → $*"; }
success() { echo "  ✓ $*"; }
warn()    { echo "  ⚠ $*"; }
abort()   { echo "  ✗ ERROR: $*" >&2; exit 1; }

step 1 "Detecting system environment..."

if [ -f /run/.toolboxenv ] || [ -f /run/.containerenv ]; then
    export IN_TOOLBOX="1"
    success "Running inside a Toolbx / container environment."
else
    warn "No container environment detected. Continuing anyway."
fi

step 2 "Detecting current shell..."

DETECTED_SHELL="$(basename "${SHELL:-}")"

case "$DETECTED_SHELL" in
    bash)
        RC_FILE="$HOME/.bashrc"
        OMP_SHELL="bash"
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        OMP_SHELL="zsh"
        ;;
    fish)
        RC_FILE="$HOME/.config/fish/config.fish"
        OMP_SHELL="fish"
        ;;
    *)
        abort "Unsupported shell '$DETECTED_SHELL'. Supported: bash, zsh, fish."
        ;;
esac

success "Shell detected: $DETECTED_SHELL (rc file: $RC_FILE)"

step 3 "Downloading Oh My Posh theme..."

mkdir -p "$THEME_DIR"
info "Target: $THEME_PATH"
info "Source: $THEME_URL"

if curl --fail --silent --show-error -o "$THEME_PATH" "$THEME_URL"; then
    success "Theme downloaded successfully."
else
    abort "Failed to download theme from $THEME_URL"
fi

step 4 "Checking Oh My Posh installation..."

if ! command -v oh-my-posh &>/dev/null; then
    abort "'oh-my-posh' was not found in PATH. Please install it first: https://ohmyposh.dev/docs/installation/linux"
fi

success "oh-my-posh found: $(command -v oh-my-posh)"

step 5 "Configuring shell rc file ($RC_FILE)..."

OMP_MARKER="# Oh My Posh — added by install.sh"

if grep -qF "$OMP_MARKER" "$RC_FILE" 2>/dev/null; then
    warn "Oh My Posh init block already present in $RC_FILE. Skipping."
else
    touch "$RC_FILE"
    {
        echo ""
        echo "$OMP_MARKER"
        if [ "$OMP_SHELL" = "fish" ]; then
            echo "oh-my-posh init $OMP_SHELL --config $THEME_PATH | source"
        else
            echo "eval \"\$(oh-my-posh init $OMP_SHELL --config $THEME_PATH)\""
        fi
        echo ""
        echo "# Oh My Posh Toolbx badge"
        if [ "$OMP_SHELL" = "fish" ]; then
            echo "if test -f /run/.toolboxenv; or test -f /run/.containerenv"
            echo "    set -x IN_TOOLBOX 1"
            echo "end"
        else
            echo "if [ -f /run/.toolboxenv ] || [ -f /run/.containerenv ]; then"
            echo "    export IN_TOOLBOX=\"1\""
            echo "fi"
        fi
    } >> "$RC_FILE"
    success "Init block appended to $RC_FILE."
fi

echo ""
echo "Done! Restart your shell or run:  source $RC_FILE"
