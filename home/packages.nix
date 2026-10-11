{
  config,
  pkgs,
  stable,
  ...
}:
{
  # ── Core CLI packages ──────────────────────────────────────────────
  home.packages =
    with pkgs;
    [
      # Shell & terminal
      zsh
      tmux

      # Editor — installed via programs.neovim in nvim.nix, not here
      # neovim

      # File listing & cat replacement
      eza
      bat

      # Directory jumping
      zoxide

      # System monitoring & info
      btop
      fastfetch

      # Git & GitHub
      git
      gh

      # Containers
      podman

      # Networking / VPN / Tunnel
      netbird
      cloudflared

      # Cloud sync
      rclone

      # JSON processor
      jq

      # Fuzzy finder
      fzf

      # Languages
      go
      bun
      nodejs

      # Search & find
      ripgrep
      fd

      # Network
      curl
      wget

      # Misc utilities
      tree
      coreutils

      # Nix tooling
      nixfmt
      nil

      # Archive tools
      unzip
      zip

      # Process management
      htop

      # Build tools (build-essential equivalent + node-gyp + python3)
      gcc
      gnumake
      python3
      node-gyp
    ]
    ++ (
      # Platform-specific packages
      if pkgs.stdenv.isDarwin then
        [
          # macOS-specific: gtimeout and friends are in coreutils
          # pinentry for SSH signing
          pinentry_mac
        ]
      else
        [
          # Linux-specific
          pinentry-curses
          killall
          wl-clipboard
        ]
    );
}
