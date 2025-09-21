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

  outputs = { self, nixpkgs, home-manager, disko, impermanence }: {
    nixosConfigurations = {
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop
          ./modules/zfs.nix
          ./modules/impermanence.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = import ./home/hbohlen;
          }
        ];
      };
      # We will define 'nix-laptop' and 'nix-server' later
    };
  };
}
