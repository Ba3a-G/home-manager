{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.rclone = {
    enable = true;
    # ── Config ─────────────────────────────────────────────────────────
    # NOTE: rclone.conf contains plaintext credentials (R2 access keys).
    # We do NOT manage secrets in Nix. The config file should be:
    #   1. Managed manually (copy to ~/.config/rclone/rclone.conf)
    #   2. Or use sops-nix / agenix for encrypted secrets
    #
    # The HM rclone module creates an empty config by default.
    # To add your R2 remote, either:
    #   - Run `rclone config` interactively, or
    #   - Use sops-nix to decrypt rclone.conf at activation
  };
}
