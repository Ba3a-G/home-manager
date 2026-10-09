{
  description = "Ba3a's cross-platform Nix Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: nix-darwin for macOS system management
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theme for tmux (fetched as source)
    catppuccin-tmux = {
      url = "github:catppuccin/tmux";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nix-darwin,
      catppuccin-tmux,
      ...
    }@inputs:
    let
      # Supported systems
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Helper to create a Home Manager configuration for a given system
      mkHomeConfig =
        {
          system,
          username ? "ba3a",
          hostname ? "server",
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs username hostname;
            stable = nixpkgs-stable.legacyPackages.${system};
          };
          modules = [
            ./home/common.nix
          ] ++ extraModules;
        };

      # Helper to create a NixOS configuration with Home Manager
      mkNixosConfig =
        {
          system,
          hostname ? "server",
          username ? "ba3a",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname username;
          };
          modules = [
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs username hostname;
                stable = nixpkgs-stable.legacyPackages.${system};
              };
              home-manager.users.${username} = import ./home/common.nix;
            }
          ];
        };

      # Helper to create a nix-darwin configuration with Home Manager
      mkDarwinConfig =
        {
          system,
          hostname ? "macbook",
          username ? "ba3a",
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname username;
          };
          modules = [
            ./hosts/darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs username hostname;
                stable = nixpkgs-stable.legacyPackages.${system};
              };
              home-manager.users.${username} = import ./home/common.nix;
            }
          ];
        };
    in
    {
      # ── Standalone Home Manager configurations (works on any Nix install) ──
      homeConfigurations = {
        # ARM Linux server (e.g. AWS Graviton, Raspberry Pi)
        "ba3a@server" = mkHomeConfig {
          system = "aarch64-linux";
          hostname = "server";
        };

        # x86_64 Linux server (if needed in future)
        "ba3a@x86-server" = mkHomeConfig {
          system = "x86_64-linux";
          hostname = "server";
        };

        # macOS (standalone HM via Determinate Systems nix installer)
        "ba3a@macbook" = mkHomeConfig {
          system = "aarch64-darwin";
          hostname = "macbook";
        };
      };

      # ── NixOS system configurations ──
      nixosConfigurations = {
        server = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "server";
        };

        arm-server = mkNixosConfig {
          system = "aarch64-linux";
          hostname = "arm-server";
        };
      };

      # ── nix-darwin system configurations (macOS) ──
      darwinConfigurations = {
        macbook = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "macbook";
        };
      };

      # ── Dev shells per system ──
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixfmt
              nil
            ];
          };
        }
      );
    };
}
