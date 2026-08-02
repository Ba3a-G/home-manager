{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.fastfetch = {
    enable = true;
    # Config is managed via home.file below because the HM module doesn't
    # support the full JSONC config format with custom logos.
  };

  # ── Fastfetch config ──────────────────────────────────────────────────
  # Copy the config and logo from the files directory
  home.file.".config/fastfetch/config.jsonc".source =
    ../files/fastfetch/config.jsonc;

  home.file.".config/fastfetch/pngs/pochita.png".source =
    ../files/fastfetch/pngs/pochita.png;
}
