{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  stable,
  lib,
  ...
}:
{
  # ── Home Manager basic config ───────────────────────────────────────
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # ── Import packages ─────────────────────────────────────────────────
  imports = [
    ./packages.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/git.nix
    ./programs/nvim.nix
    ./programs/fastfetch.nix
    ./programs/btop.nix
    ./programs/gh.nix
    ./programs/bat.nix
    ./programs/eza.nix
    ./programs/zoxide.nix
    ./programs/rclone.nix
    ./programs/thefuck.nix # pay-respects (thefuck successor)
  ];

  # ── XDG / config directory ──────────────────────────────────────────
  xdg.enable = true;

  # ── Home file: p10k.zsh (managed as static file) ────────────────────
  # The p10k config is 200+ lines of generated wizard output — not worth
  # translating to Nix. We copy it from the local files directory.
  home.file.".p10k.zsh".source = ./files/p10k.zsh;

  # ── Global gitignore ────────────────────────────────────────────────
  # Managed here so it's consistent across platforms
  home.file.".config/git/ignore".text = ''
    **/.claude/settings.local.json
  '';

  # ── SSH signing allowed_signers ────────────────────────────────────
  # Required for git commit SSH signing
  home.file.".config/git/allowed_signers".text = ''
    mail@ba3a.tech ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9eRvccK99jlSyJvcjwxMtGpFtCLS6qIUxeOx+0ac02
  '';

  # ── Fonts (Nerd Font for terminals & editors) ───────────────────────
  fonts.fontconfig.enable = true;

  # ── News display ────────────────────────────────────────────────────
  news.display = "silent";
}
