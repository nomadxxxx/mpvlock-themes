#!/bin/bash

# Bash script to download and install mpvlock themes from GitHub, with option to install mpvlock

# ASCII header and UI
cat << "EOF"
███╗   ███╗██████╗ ██╗   ██╗██╗      ██████╗  ██████╗██╗  ██╗
████╗ ████║██╔══██╗██║   ██║██║     ██╔═══██╗██╔════╝██║ ██╔╝
██╔████╔██║██████╔╝██║   ██║██║     ██║   ██║██║     █████╔╝ 
██║╚██╔╝██║██╔═══╝ ╚██╗ ██╔╝██║     ██║   ██║██║     ██╔═██╗ 
██║ ╚═╝ ██║██║      ╚████╔╝ ███████╗╚██████╔╝╚██████╗██║  ██╗
╚═╝     ╚═╝╚═╝       ╚═══╝  ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝
######################MPVLOCK INSTALLER#####################
EOF

# Repository URL for downloading themes
RAW_BASE_URL="https://raw.githubusercontent.com/nomadxxxx/mpvlock-themes/main"
THEMES_DIR="$HOME/.config/mpvlock/themes"
CONFIG_DIR="$HOME/.config/mpvlock"

# Static list of themes and their corresponding video files
THEMES=("cat-pool" "cherry-blossom" "elon" "gothgirl" "neon_jinx" "solitude")
declare -A VIDEO_FILES=(
    ["cat-pool"]="6.mp4"
    ["cherry-blossom"]="cherry.mp4"
    ["elon"]="9.mp4"
    ["gothgirl"]="7.mp4"
    ["neon_jinx"]="neon_jinx.mp4"
    ["solitude"]="1.mp4"
)

# Check for required tools
command -v curl >/dev/null 2>&1 || { echo "Error: curl is required but not installed. Please install it (e.g., 'sudo apt install curl' on Ubuntu, 'sudo pacman -S curl' on Arch)." >&2; exit 1; }

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package based on the distro
install_package() {
    local pkg_name="$1"
    local arch_pkg="$2"
    local ubuntu_pkg="$3"
    local fedora_pkg="$4"

    if check_command "$pkg_name"; then
        echo "$pkg_name is already installed."
        return 0
    fi

    echo "Installing $pkg_name..."
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y "$ubuntu_pkg" || { echo "Error: Failed to install $ubuntu_pkg on Debian/Ubuntu."; exit 1; }
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm "$arch_pkg" || { echo "Error: Failed to install $arch_pkg on Arch."; exit 1; }
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "$fedora_pkg" || { echo "Error: Failed to install $fedora_pkg on Fedora."; exit 1; }
    else
        echo "Error: Unsupported package manager. Please install $pkg_name manually."
        exit 1
    fi
}

# Function to compile and install a package from GitHub
compile_and_install() {
    local repo_url="$1"
    local pkg_name="$2"

    if check_command "$pkg_name"; then
        echo "$pkg_name is already installed."
        return 0
    fi

    echo "Cloning and compiling $pkg_name from $repo_url..."
    TEMP_DIR=$(mktemp -d)
    git clone "$repo_url" "$TEMP_DIR/$pkg_name" || { echo "Error: Failed to clone $pkg_name repository."; exit 1; }
    cd "$TEMP_DIR/$pkg_name" || { echo "Error: Failed to change directory to $pkg_name."; exit 1; }
    mkdir -p build
    cd build || { echo "Error: Failed to create build directory."; exit 1; }
    cmake -GNinja .. || { echo "Error: CMake configuration failed for $pkg_name."; exit 1; }
    ninja || { echo "Error: Compilation failed for $pkg_name."; exit 1; }
    sudo ninja install || { echo "Error: Installation failed for $pkg_name."; exit 1; }
    cd / && rm -rf "$TEMP_DIR"
    echo "$pkg_name installation complete."
}

# Function to check if mpvlock is installed and install it if not
install_mpvlock() {
    echo "Starting mpvlock installation process..."

    if check_command mpvlock; then
        echo "mpvlock is already installed on this system."
        return 0
    fi

    echo "mpvlock is not installed. Beginning installation..."

    # Install basic dependencies available in package managers
    echo "Installing dependencies..."
    install_package "git" "git" "git" "git"
    install_package "cmake" "cmake" "cmake" "cmake"
    install_package "ninja" "ninja" "ninja-build" "ninja-build"
    install_package "cairo" "cairo" "libcairo2-dev" "cairo-devel"
    install_package "file" "file" "file" "file"
    install_package "libdrm" "libdrm" "libdrm-dev" "libdrm-devel"
    install_package "libxkbcommon" "libxkbcommon" "libxkbcommon-dev" "libxkbcommon-devel"
    install_package "mesa" "mesa" "libgl1-mesa-dev" "mesa-libGL-devel"
    install_package "mpv" "mpv" "libmpv-dev" "mpv-libs-devel"
    install_package "pam" "pam" "libpam0g-dev" "pam-devel"
    install_package "pango" "pango" "libpango1.0-dev" "pango-devel"
    install_package "wayland" "wayland" "libwayland-dev" "wayland-devel"
    install_package "wayland-protocols" "wayland-protocols" "wayland-protocols" "wayland-protocols-devel"

    # Install build tools
    echo "Installing build tools..."
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y build-essential || { echo "Error: Failed to install build-essential on Debian/Ubuntu."; exit 1; }
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm base-devel || { echo "Error: Failed to install base-devel on Arch."; exit 1; }
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y gcc-c++ make || { echo "Error: Failed to install build tools on Fedora."; exit 1; }
    else
        echo "Error: Unsupported package manager. Please install build tools (cmake, gcc/g++, make) manually."
        exit 1
    fi

    # Compile dependencies not available in package managers
    echo "Compiling Hyprland dependencies..."
    compile_and_install "https://github.com/hyprwm/hyprutils" "hyprutils"
    compile_and_install "https://github.com/hyprwm/hyprlang" "hyprlang"
    compile_and_install "https://github.com/hyprwm/hyprgraphics" "hyprgraphics"
    compile_and_install "https://github.com/hyprwm/hyprwayland-scanner" "hyprwayland-scanner"
    compile_and_install "https://github.com/GhostNaN/mpvpaper" "mpvpaper"

    # Optional: Install hypridle
    echo "Installing optional dependency: hypridle..."
    compile_and_install "https://github.com/hyprwm/hypridle" "hypridle"

    # For Arch-based systems, try installing mpvlock-git via AUR if an AUR helper is available
    if command -v pacman >/dev/null 2>&1; then
        AUR_HELPER=""
        if command -v yay >/dev/null 2>&1; then
            AUR_HELPER="yay"
        elif command -v paru >/dev/null 2>&1; then
            AUR_HELPER="paru"
        fi

        if [ -n "$AUR_HELPER" ]; then
            echo "Detected AUR helper: $AUR_HELPER. Attempting to install mpvlock-git..."
            $AUR_HELPER -S --noconfirm mpvlock-git || { echo "Error: Failed to install mpvlock-git via $AUR_HELPER."; exit 1; }
            echo "mpvlock installation complete via AUR."
            return 0
        else
            echo "No AUR helper (yay or paru) found. Falling back to manual compilation..."
        fi
    fi

    # Compile mpvlock
    echo "Compiling and installing mpvlock..."
    compile_and_install "https://github.com/nomadxxxx/mpvlock" "mpvlock"
    echo "mpvlock installation process completed."
}

# Function to download a file with curl and stream it to a destination
download_file() {
    local url="$1"
    local dest="$2"
    echo "Downloading $(basename "$dest")..."
    curl -L -s "$url" -o "$dest" || { echo "Error: Failed to download $(basename "$dest")."; return 1; }
    return 0
}

# Function to install the selected theme
install_theme() {
    local theme="$1"
    echo "Installing theme: $theme..."

    # Create the theme directory (overwrite if it exists)
    THEME_DIR="$THEMES_DIR/$theme"
    mkdir -p "$THEME_DIR"

    # Get the video file name for this theme
    VIDEO_FILE=${VIDEO_FILES[$theme]}
    if [ -z "$VIDEO_FILE" ]; then
        echo "Error: Video file not defined for theme $theme."
        exit 1
    fi

    # Download the mpvlock.conf file
    download_file "$RAW_BASE_URL/$theme/mpvlock.conf" "$THEME_DIR/mpvlock.conf" || exit 1

    # Download the video file
    download_file "$RAW_BASE_URL/$theme/$VIDEO_FILE" "$THEME_DIR/$VIDEO_FILE" || exit 1

    # Verify the files exist
    [ -f "$THEME_DIR/mpvlock.conf" ] || { echo "Error: mpvlock.conf not found after download."; exit 1; }
    [ -f "$THEME_DIR/$VIDEO_FILE" ] || { echo "Error: $VIDEO_FILE not found after download."; exit 1; }

    # Copy the mpvlock.conf to the config directory
    mkdir -p "$CONFIG_DIR"
    cp "$THEME_DIR/mpvlock.conf" "$CONFIG_DIR/mpvlock.conf" || { echo "Error: Failed to copy mpvlock.conf for $theme."; exit 1; }

    echo "Theme $theme installed successfully!"
}

# Check if running non-interactively (e.g., piped from curl)
if [[ ! "$-" =~ i ]]; then
    # Non-interactive mode (no 'i' in $- indicates non-interactive)
    if [ "$1" = "-t" ] && [ -n "$2" ]; then
        # Install specific theme
        SELECTED_THEME="$2"
        if [[ " ${THEMES[@]} " =~ " $SELECTED_THEME " ]]; then
            install_theme "$SELECTED_THEME"
            echo "Theme $SELECTED_THEME has been installed successfully! Restart mpvlock to apply the new theme."
            exit 0
        else
            echo "Error: Theme '$SELECTED_THEME' is not recognized. Available themes are: ${THEMES[@]}"
            exit 1
        fi
    else
        # Default action: install mpvlock
        echo "Running in non-interactive mode. Installing mpvlock by default..."
        install_mpvlock
        exit 0
    fi
fi

# Interactive mode
while true; do
    # Display menu
    cat << "EOF"
Available options:
1) Install mpvlock 
###########################THEMES ##########################
EOF
    for i in "${!THEMES[@]}"; do
        printf "%d) %s\t\n" $((i + 2)) "${THEMES[$i]}"
    done
    echo "$(( ${#THEMES[@]} + 2 ))) EXIT"

    # Get user selection
    if ! read -t 1 -p "Enter your choice: " CHOICE; then
        echo "No input received. Exiting."
        exit 1
    fi

    # Validate input is a number
    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
        echo "Invalid option. Please enter a number."
        continue
    fi

    # Handle choices
    if [ "$CHOICE" -eq 1 ]; then
        echo "Selected option 1: Installing mpvlock..."
        install_mpvlock
    elif [ "$CHOICE" -ge 2 ] && [ "$CHOICE" -le $(( ${#THEMES[@]} + 1 )) ]; then
        SELECTED_THEME=${THEMES[$((CHOICE - 2))]}
        install_theme "$SELECTED_THEME"
        echo "Theme $SELECTED_THEME has been installed successfully! Restart mpvlock to apply the new theme."
    elif [ "$CHOICE" -eq $(( ${#THEMES[@]} + 2 )) ]; then
        echo "Exiting."
        exit 0
    else
        echo "Invalid option. Please try again."
    fi
done