{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;

    # ── Default options ─────────────────────────────────────────────────
    # These are passed as flags to every eza invocation
    extraOptions = [
      "--color-scale"
      "--group-directories-first"
      "--icons"
    ];
  };
}
