{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;

    # Use the latest Neovim from nixpkgs
    defaultEditor = true;

    # Silence stateVersion warnings — we don't need Ruby/Python3 providers
    withRuby = false;
    withPython3 = false;

    # ── Neovim config ──────────────────────────────────────────────────
    # The kickstart.nvim config is complex (init.lua + lua/ directory tree).
    # We copy the entire nvim config from the dotfiles repo via home.file.
    # This keeps the yadm-managed config intact and avoids re-implementing
    # the entire kickstart setup in Nix.

    # ── Extra runtime dependencies ─────────────────────────────────────
    # These are tools that the kickstart config expects to find in PATH
    extraPackages =
      with pkgs;
      [
        # Treesitter compilers
        gcc
        tree-sitter

        # LSP servers (the kickstart config uses mason.nvim to install others)
        lua-language-server
        nil # Nix LSP

        # Formatters
        stylua

        # Fuzzy finder backend for telescope
        ripgrep
        fd

        # Git signs dependency
        git
      ]
      ++ (
        # Clipboard provider — Linux only (macOS uses pbcopy/pbpaste)
        if pkgs.stdenv.isDarwin then
          [ ]
        else
          [ wl-clipboard ]
      );

    # ── Vim config ─────────────────────────────────────────────────────
    # Minimal extra config — the real config is in init.lua from dotfiles
    extraConfig = ''
      " Leader is set in init.lua
    '';
  };

  # ── Copy kickstart.nvim config from dotfiles repo ─────────────────────
  # The nvim config directory is managed as a whole tree via home.file
  # Source: the dotfiles repo's .config/nvim/ directory
  # We use a local path reference — update this to point to your dotfiles
  # or keep using yadm to manage the nvim config separately.
  #
  # Option A: Copy from flake input (uncomment if you add nvim-config as input)
  # home.file.".config/nvim".source = "${inputs.nvim-config}";

  # Option B: Let yadm manage nvim config (recommended for now)
  # Neovim binary is installed via Nix, config stays with yadm.
  # This is the default — no home.file needed.
}
