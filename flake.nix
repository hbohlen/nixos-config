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
          imports = [ ./modules/zfs.nix ];
          # This is the fix: pass pkgs into the module
          _module.args = { inherit inputs pkgs; };
        };
      };

      nixosConfigurations = {
        "nixos-desktop" = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop
            ./modules/zfs.nix
            ./modules/impermanence.nix
            inputs.home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hbohlen = import ./home/hbohlen/default.nix;
            }
          ];
        };
      };
    };
}
