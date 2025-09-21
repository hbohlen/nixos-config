{
  description = "hbohlen's NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self, ... }@inputs:
    let
      # Define the system architecture once
      system = "x86_64-linux";
      # Create a pkgs set for the specified system
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      diskoConfigurations = {
        "nixos-desktop" = {
          disko.devices = {
            disk = {
              main = {
                type = "disk";
                device = "/dev/nvme1n1";
                content = {
                  type = "gpt";
                  partitions = {
                    boot = {
                      size = "1M";
                      type = "EF02";
                    };
                    ESP = {
                      size = "512M";
                      type = "EF00";
                      content = {
                        type = "filesystem";
                        format = "vfat";
                        mountpoint = "/boot";
                      };
                    };
                    zfs = {
                      size = "100%";
                      content = {
                        type = "zfs";
                        pool = "zroot";
                      };
                    };
                  };
                };
              };
            };
            zpool = {
              zroot = {
                type = "zpool";
                options = {
                  autotrim = "on";
                  ashift = "12";
                };
                rootFsOptions = {
                  mountpoint = "none";
                  compression = "zstd";
                  "com.sun:auto-snapshot" = "false";
                };
                datasets = {
                  "nix" = { type = "zfs_fs"; mountpoint = "/nix"; };
                  "home" = { type = "zfs_fs"; mountpoint = "/home"; };
                  "persist" = {
                    type = "zfs_fs";
                    mountpoint = "/persist";
                  };
                };
              };
            };
          };
        };
      };

      nixosConfigurations = {
        "nixos-desktop" = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop
            inputs.disko.nixosModules.disko  # Add this line to import the disko module
            ./modules/zfs.nix
            ./modules/impermanence.nix
            inputs.home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hbohlen = import ./home/hbohlen/home.nix;
            }
          ];
        };
      };
    };
}
