{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;

    # ── Use XDG config directory for zsh ───────────────────────────────
    dotDir = "${config.xdg.configHome}/zsh";

    # ── Oh-My-Zsh ──────────────────────────────────────────────────────
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "git"
      ];
    };

    # ── History ────────────────────────────────────────────────────────
    history = {
      size = 1000;
      save = 1000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      findNoDups = true;
      saveNoDups = true;
      share = true;
      append = true;
    };

    # ── Shell options ──────────────────────────────────────────────────
    setOptions = [
      "appendhistory"
      "sharehistory"
      "hist_ignore_space"
      "hist_ignore_all_dups"
      "hist_save_no_dups"
      "hist_find_no_dups"
    ];

    # ── Aliases (ported from .zshrc) ───────────────────────────────────
    shellAliases = {
      # eza aliases
      ls = "eza --color=always --group-directories-first --icons";
      la = "eza -a --color=always --group-directories-first --icons";
      ll = "eza -l --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      "l." = "eza -a | egrep '^\\.'";

      # bat as cat
      cat = "bat --style header --style snip --style changes --style header";

      # nvim as vim
      vim = "nvim";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # grep colors
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

      # Misc
      ip = "ip -color";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";

      # Docker (if installed)
      dps = "docker ps";

      # macOS-specific (harmless on Linux)
      disablesleep = "sudo pmset disablesleep 1";
      enablesleep = "sudo pmset disablesleep 0";

      # Power
      fuckoff = "sudo shutdown -h now";

      # gtimeout on macOS, timeout on Linux
      timeout = if pkgs.stdenv.isDarwin then "gtimeout" else "timeout";
    };

    # ── Init content (runs after oh-my-zsh) ────────────────────────────
    initContent = ''
      # ── Powerlevel10k theme ──────────────────────────────────────────
      # Source p10k theme from the nix store
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Source p10k config (managed by home.file in common.nix)
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # ── zsh-syntax-highlighting ──────────────────────────────────────
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      # ── zsh-autosuggestions ──────────────────────────────────────────
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      # ── PATH additions ───────────────────────────────────────────────
      export PATH="$HOME/.local/bin:$PATH"

      # Go binaries
      export PATH="$PATH:$HOME/go/bin"

      # Bun
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"

      # pnpm (if installed)
      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # ── Disable magic functions (fixes paste issues) ─────────────────
      DISABLE_MAGIC_FUNCTIONS="true"

      # ── Completion waiting dots ──────────────────────────────────────
      COMPLETION_WAITING_DOTS="true"

      # ── fpath for custom completions ──────────────────────────────────
      fpath+=~/.config/eza-completions/zsh
    '';
  };
}
