{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  lib,
  ...
}:
{
  # ── Bootloader ────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ───────────────────────────────────────────────────────
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
      ];
    };
  };

  # ── Time & Locale ────────────────────────────────────────────────────
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # ── User account ──────────────────────────────────────────────────────
  users.users.${username} = {
    isNormalUser = true;
    description = "Aryan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... mail@ba3a.tech"
    ];
  };

  # ── Enable Zsh system-wide ────────────────────────────────────────────
  programs.zsh.enable = true;

  # ── SSH server ────────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  # ── System packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
  ];

  # ── Nix settings ──────────────────────────────────────────────────────
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ username ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # ── Docker (optional) ─────────────────────────────────────────────────
  virtualisation.docker.enable = true; # Set to true if needed

  # ── Fonts (Nerd Font for terminals) ───────────────────────────────────
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "CaskaydiaCove" ];
    })
  ];

  # ── This value determines the NixOS release ───────────────────────────
  system.stateVersion = "24.11";
  system.autoUpgrade.enable = false; # Set to true for auto-upgrades
}
