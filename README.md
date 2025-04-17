# mpvlock-themes

This repository contains themes and an installer script for **mpvlock**, a more theme and rice friendly fork of hyprlock. The included `mpvlock_theme_installer.sh` script allows you to easily install mpvlock and apply various themes with their corresponding video backgrounds, minimizing large downloads by avoiding the need to clone the entire repo.

## Install

Install mpvlock or a specific theme directly without cloning the repository:

- **Install a specific theme** (e.g., `cherry-blossom`):
  ```bash
  curl -L https://raw.githubusercontent.com/nomadxxxx/mpvlock-themes/main/mpvlock_theme_installer.sh | bash -s - -t cherry-blossom
  ```
  Replace `cherry-blossom` with any available theme name (see below).
## Installation (Manual Method)

1. **Prerequisites**:
   - `curl` must be installed on your system.
   - Git, CMake, Ninja, and various development libraries will be installed automatically by the script if missing (hopfully).

2. **Clone the Repository** (optional for advanced users):
   ```bash
   git clone https://github.com/nomadxxxx/mpvlock-themes.git
   cd mpvlock-themes
   ```

3. **Run the Installer**:
   ```bash
   chmod +x mpvlock_theme_installer.sh
   ./mpvlock_theme_installer.sh
   ```
   - Follow the on-screen menu to install mpvlock (option 1) or select a theme (options 2-7).
   - Themes are installed to `~/.config/mpvlock/themes/`, and the configuration is updated accordingly.

## Available Themes

The following themes are included:
- `cat-pool`: Features a playful cat-themed video.
- `cherry-blossom`: Showcases cute animoo with cherry blossom animation.
- `elon`: space launch (video: `9.mp4`).
- `gothgirl`: Dark animoo girl.
- `neon_jinx`: neon effects with `neon_jinx.mp4`.
- `solitude`: animoo girl pondering universe (arguably best) `1.mp4`.

## Detailed Previews

| **cat-pool** | **cherry-blossom** |
|:--:|:--:|
| <img src="https://github.com/nomadxxxx/mpvlock-themes/blob/main/assets/cat-pool.png" width="500"> | <img src="https://github.com/nomadxxxx/mpvlock-themes/blob/main/assets/cherry-blossom.png" width="500"> |

| **elon** | **gothgirl** |
|:--:|:--:|
| <img src="https://github.com/nomadxxxx/mpvlock-themes/blob/main/assets/elon.png" width="500"> | <img src="https://github.com/nomadxxxx/mpvlock-themes/blob/main/assets/gothgirl.png" width="500"> |

| **solitude** | **Neon Jinx** |
|:--:|:--:|
| <img src="https://github.com/nomadxxxx/mpvlock-themes/blob/main/assets/solitude.png" width="500"> | <img src="https://github.com/nomadxxxx/hyprddm/raw/master/Previews/neon_jinx.png" width="500"> |

## Usage

1. **Install mpvlock**: Select option 1 from the installer menu or use the one-line install.
2. **Apply a Theme**: Choose a theme (options 2-7) via the menu or specify it with the `-t` flag in the one-line install.
3. **Restart mpvlock**: After installing a theme, restart mpvlock to see the changes.

## Notes
- The installer uses static theme definitions to avoid large downloads.
- Ensure the `RAW_BASE_URL` in the script matches the correct repository path if you host themes elsewhere.
- For issues or contributions, please open an issue or submit a pull request.
