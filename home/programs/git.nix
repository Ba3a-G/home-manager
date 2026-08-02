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
    settings = {
      user = {
        name = "Aryan";
        email = "mail@ba3a.tech";
      };

      # ── Signing ────────────────────────────────────────────────────
      gpg = {
        format = "ssh";
      };
      gpg.ssh = {
        allowedSignersFile = "~/.config/git/allowed_signers";
      };

      # ── Aliases ────────────────────────────────────────────────────
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        sw = "switch";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };

      # ── Extra config ───────────────────────────────────────────────
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      diff.colorMoved = "default";
      branch.sort = "-committerdate";
      core.editor = "nvim";
    };

    # ── Signing (HM module option, not renamed) ───────────────────────
    signing = {
      key = "~/.ssh/id_awsstaging.pub";
      signByDefault = true;
    };
  };
}
