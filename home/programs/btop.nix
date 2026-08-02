{
  config,
  pkgs,
  lib,
  ...
}:
{
  # ── btop system monitor ───────────────────────────────────────────────
  # btop doesn't have a HM module, so we just install it (in packages.nix)
  # and manage the config file via home.file.
  home.file.".config/btop/btop.conf".source =
    ../files/btop/btop.conf;
}
