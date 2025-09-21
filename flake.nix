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

  # This is the line that has been changed
  outputs = { self, ... }@inputs: {
    nixosConfigurations = {
      "nix-desktop" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Now 'inputs' is correctly defined and can be passed down
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop
          ./modules/zfs.nix
          ./modules/impermanence.nix
          inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = import ./home/hbohlen;
          }
        ];
      };
    };
  };
}

