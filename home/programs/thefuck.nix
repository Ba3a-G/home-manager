{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };
}
