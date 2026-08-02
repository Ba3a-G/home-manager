{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.tmux = {
    enable = true;

    # ── Terminal settings ──────────────────────────────────────────────
    terminal = "tmux-256color";
    mouse = true;
    shortcut = "C-Space"; # prefix key

    # ── Pass-through (for truecolor in nested terminals) ─────────────────
    extraConfig = ''
      set-option -g allow-passthrough on

      # ── Split panes using | and - ────────────────────────────────────
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # ── Catppuccin theme ─────────────────────────────────────────────
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "rounded"

      # ── Status line ──────────────────────────────────────────────────
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      set -agF status-right "#{E:@catppuccin_status_battery}"
    '';

    # ── Plugins ────────────────────────────────────────────────────────
    plugins = with pkgs.tmuxPlugins; [
      # Catppuccin theme
      catppuccin

      # CPU usage in status bar
      cpu

      # Battery status in status bar
      battery

      # Sensible defaults
      sensible

      # Yank to system clipboard
      yank
    ];
  };
}
