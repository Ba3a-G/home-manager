{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;

    # ── User config (ported from .gitconfig) ────────────────────────────
    userName = "Aryan";
    userEmail = "mail@ba3a.tech";

    # ── Signing ────────────────────────────────────────────────────────
    signing = {
      key = "~/.ssh/id_mac.pub";
      signByDefault = true;
    };

    # ── Aliases ────────────────────────────────────────────────────────
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      sw = "switch";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };

    # ── Extra config (merged — Nix doesn't allow duplicate attrs) ──────
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      gpg.ssh = {
        allowedSignersFile = "~/.config/git/allowed_signers";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      diff.colorMoved = "default";
      branch.sort = "-committerdate";
      core.editor = "nvim";
    };
  };
}
