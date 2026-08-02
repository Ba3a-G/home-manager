{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.bat = {
    enable = true;

    # ── Bat config ─────────────────────────────────────────────────────
    config = {
      theme = "Catppuccin Mocha";
      style = "header,snip,changes";
    };
  };

  # ── Catppuccin theme for bat ─────────────────────────────────────────
  # Fetch the Catppuccin bat theme from GitHub
  # NOTE: The sha256 hash below is a placeholder (lib.fakeSha256). After
  # your first `nix build`, Nix will tell you the correct hash — paste it here.
  home.file.".config/bat/themes/Catppuccin Mocha.tmTheme".source =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme";
      sha256 = lib.fakeSha256;
    };
}
