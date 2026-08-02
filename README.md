# Ba3a's Nix Home Manager Configuration

A cross-platform Nix flake that manages CLI packages and dotfiles via Home Manager.
Works on **NixOS**, **any Linux distro with Nix**, and **macOS** (via nix-darwin or standalone).

## What's Included

### CLI Tools
| Tool | Purpose |
|------|---------|
| `zsh` + `oh-my-zsh` + `powerlevel10k` | Shell with Pure-style prompt |
| `neovim` | Editor (kickstart.nvim config via yadm) |
| `tmux` | Terminal multiplexer (catppuccin mocha theme) |
| `eza` | Modern `ls` replacement |
| `bat` | Modern `cat` replacement (catppuccin theme) |
| `zoxide` | Smart directory jumping |
| `btop` | System resource monitor |
| `fastfetch` | System info display (neofetch alternative) |
| `git` + `gh` | Version control + GitHub CLI |
| `rclone` | Cloud storage sync |
| `thefuck` | Command correction |
| `jq` | JSON processor |
| `fzf` | Fuzzy finder |
| `ripgrep` / `fd` | Fast search / find |
| `tree` | Directory tree viewer |

### Languages
| Tool | Purpose |
|------|---------|
| `go` | Go language |
| `bun` | JavaScript runtime & package manager |

## Structure

```
home-manager/
├── flake.nix                    # Flake entry point
├── home/
│   ├── common.nix               # Shared Home Manager config
│   ├── packages.nix             # Package list
│   ├── programs/
│   │   ├── zsh.nix              # Zsh + oh-my-zsh + p10k + aliases
│   │   ├── tmux.nix             # Tmux + catppuccin + plugins
│   │   ├── git.nix              # Git config + SSH signing
│   │   ├── nvim.nix             # Neovim (binary only, config via yadm)
│   │   ├── fastfetch.nix        # Fastfetch config
│   │   ├── btop.nix             # Btop config
│   │   ├── gh.nix               # GitHub CLI
│   │   ├── bat.nix              # Bat (catppuccin theme)
│   │   ├── eza.nix              # Eza (ls replacement)
│   │   ├── zoxide.nix           # Zoxide
│   │   ├── rclone.nix           # Rclone (no secrets in Nix)
│   │   └── thefuck.nix          # The Fuck
│   └── files/                   # Static config files copied via home.file
│       ├── p10k.zsh             # Powerlevel10k config (from dotfiles)
│       ├── fastfetch/
│       │   └── config.jsonc     # Fastfetch config (from dotfiles)
│       └── btop/
│           └── btop.conf        # Btop config (from dotfiles)
├── hosts/
│   ├── nixos/
│   │   └── configuration.nix    # NixOS server system config
│   └── darwin/
│       └── configuration.nix    # macOS system config (nix-darwin)
└── README.md                   # This file
```

## Setup

### Option 1: NixOS (Server)

1. Copy this directory to the server (e.g., to `~/.config/home-manager/`)
2. Edit `hosts/nixos/configuration.nix` — add your SSH public key
3. Build and switch:

```bash
sudo nixos-rebuild switch --flake .#server
```

### Option 2: Standalone Home Manager (Any Linux)

1. Install Nix:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Install Home Manager:
```bash
nix run home-manager/release-24.11 -- init --switch .#ba3a@server
```

Or if you already have Home Manager:
```bash
home-manager switch --flake .#ba3a@server
```

### Option 3: macOS (nix-darwin)

1. Install Nix (Determinate Systems installer recommended):
```bash
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | sh -s -- install
```

2. Install nix-darwin:
```bash
nix run nix-darwin -- switch --flake .#macbook
```

### Option 4: macOS (Standalone Home Manager)

1. Install Nix (see above)
2. Install Home Manager standalone:
```bash
nix run home-manager/release-24.11 -- init --switch .#ba3a@macbook
```

## Post-Install

### Copy dotfiles with yadm

The Nix config installs the **binaries**. Your dotfiles (nvim config, p10k, etc.)
are still managed by yadm:

```bash
yadm clone https://github.com/ba3a-g/dotfiles
```

### Set up rclone manually

Rclone config contains secrets and is NOT managed by Nix:

```bash
rclone config
# Or copy your existing rclone.conf to ~/.config/rclone/rclone.conf
```

### Set up SSH signing key for git

```bash
# Generate SSH key (if not already done)
ssh-keygen -t ed25519 -C "mail@ba3a.tech"

# Add the public key to ~/.config/git/allowed_signers
echo "mail@ba3a.tech $(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers
```

## Updating

### Update flake inputs
```bash
nix flake update
```

### Apply changes
```bash
# NixOS
sudo nixos-rebuild switch --flake .#server

# Standalone Home Manager
home-manager switch --flake .#ba3a@server

# macOS (nix-darwin)
darwin-rebuild switch --flake .#macbook
```

## Notes

- **Secrets:** `rclone.conf` and `llogin/config.toml` contain plaintext credentials.
  These are NOT managed by Nix. Copy them manually or use `sops-nix`/`agenix`.
- **Neovim config:** The kickstart.nvim config is managed by yadm, not Nix.
  Nix only installs the `neovim` binary and its runtime dependencies (treesitter,
  LSP servers, formatters).
- **p10k.zsh:** Managed as a static file via `home.file`. To update, edit
  `home/files/p10k.zsh` and rebuild.
- **bat theme:** The Catppuccin bat theme fetches from GitHub. You may need to
  update the `sha256` hash after the first build (run `nix build` and copy the
  expected hash from the error message).
- **Platform differences:** `timeout` alias uses `gtimeout` on macOS (from
  `coreutils`) and `timeout` on Linux.
