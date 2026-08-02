{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.gh = {
    enable = true;

    # ── Settings ───────────────────────────────────────────────────────
    settings = {
      gitProtocol = "https";
      prompt = "enabled";

      aliases = {
        co = "pr checkout";
      };
    };
  };
}
