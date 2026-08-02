{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  lib,
  ...
}:
{
  # ── nix-darwin system configuration ───────────────────────────────────
  # This is for macOS systems using nix-darwin + Home Manager.
  # The Home Manager config is imported via the flake (see flake.nix).

  # ── Nix settings ──────────────────────────────────────────────────────
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ username ];
    };
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  # ── Enable flakes & nix-darwin ────────────────────────────────────────
  nix.enable = true;

  # ── User ──────────────────────────────────────────────────────────────
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # ── Zsh ───────────────────────────────────────────────────────────────
  programs.zsh.enable = true;

  # ── Homebrew (for casks not in nixpkgs) ────────────────────────────────
  homebrew = {
    enable = true;
    brews = [ ];
    casks = [ ];
    onActivation.cleanup = "uninstall";
  };

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "CaskaydiaCove" ];
    })
  ];

  # ── System defaults ───────────────────────────────────────────────────
  system = {
    stateVersion = 5;
    defaults = {
      # Dock
      dock.autohide = true;
      dock.orientation = "bottom";

      # Finder
      finder.showPathbar = true;
      finder.showStatusBar = true;

      # Trackpad
      trackpad.tapToClick = true;
    };
  };
}
