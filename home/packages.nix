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

      # Editor
      neovim

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

      # Cloud sync
      rclone

      # JSON processor
      jq

      # Fuzzy finder
      fzf

      # Languages
      go
      bun

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
      nixfmt-rfc-style
      nil

      # Archive tools
      unzip
      zip

      # Process management
      htop
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
