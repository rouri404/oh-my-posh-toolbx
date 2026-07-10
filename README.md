# Oh My Posh theme for Toolbx

This repository demonstrates how to add a Toolbx badge to [Oh My Posh](https://ohmyposh.dev), showing a visual indicator when the terminal session is running inside a [toolbx](https://containertoolbx.org) or OCI container environment. The [`tonybaloney-mod`](tonybaloney-mod.omp.json) theme is used here as an example, but the same approach can be replicated for any Oh My Posh theme.

![Theme preview](https://raw.githubusercontent.com/rouri404/oh-my-posh-toolbx/refs/heads/main/assets/tonybaloney-mod.png)

> [!IMPORTANT]
> The theme is a modified version of [`tonybaloney`](https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/tonybaloney.omp.json) ([Oh My Posh themes](https://ohmyposh.dev/docs/themes#tonybaloney)), named [`tonybaloney-mod`](tonybaloney-mod.omp.json).

The tool icon ![#CE93D8](https://placehold.co/15x15/CE93D8/CE93D8.png) `#CE93D8` on the left is only visible when inside a Toolbx or OCI container — it disappears on a regular shell session.

---

## How it works

The detection mechanism relies on a simple environment variable check. Toolbx and other OCI container environments (such as Distrobox) typically create specific indicator files inside the container, like `/run/.toolboxenv` or `/run/.containerenv`. 

When you initialize your shell, a small script checks for the existence of these files. If they are found, it exports an environment variable (`IN_TOOLBOX="1"`).

The modified Oh My Posh theme includes a text segment that uses a conditional template to display the tool badge only when this environment variable is present:

```json
{
  "type": "text",
  "template": "{{ if .Env.IN_TOOLBOX }} \ue20f {{ end }}"
}
```

---

## Requirements

- [Oh My Posh](https://ohmyposh.dev/docs/installation/linux) installed and available in `PATH`
- A [Nerd Font](https://www.nerdfonts.com/) configured in your terminal emulator
- A supported shell: **bash**, **zsh**, or **fish**
- `curl` available in the system

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/rouri404/oh-my-posh-toolbx/main/install.sh | bash
```

The script will detect your shell, download the theme, and append the Oh My Posh init block to your rc file automatically.

After running, restart your shell or source the rc file:

```bash
source ~/.bashrc                      # bash
source ~/.zshrc                       # zsh
source ~/.config/fish/config.fish     # fish
```

## Manual installation

<details>
<summary>Click to expand</summary>

**1. Download the theme:**

```bash
curl -o ~/.poshthemes/tonybaloney-mod.omp.json \
  https://raw.githubusercontent.com/rouri404/oh-my-posh-toolbx/main/tonybaloney-mod.omp.json
```

**2. Add the Oh My Posh init line to your rc file:**

```bash
# bash (~/.bashrc) or zsh (~/.zshrc)
eval "$(oh-my-posh init bash --config ~/.poshthemes/tonybaloney-mod.omp.json)"
```

```fish
# fish (~/.config/fish/config.fish)
oh-my-posh init fish --config ~/.poshthemes/tonybaloney-mod.omp.json | source
```

**3. Add the Toolbx detection to your rc file:**

```bash
# bash (~/.bashrc) or zsh (~/.zshrc)
if [ -f /run/.toolboxenv ] || [ -f /run/.containerenv ]; then
    export IN_TOOLBOX="1"
fi
```

```fish
# fish (~/.config/fish/config.fish)
if test -f /run/.toolboxenv; or test -f /run/.containerenv
    set -x IN_TOOLBOX 1
end
```

**4. Restart your shell or source the rc file.**


</details>
