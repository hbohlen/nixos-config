{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # This will be generated during installation
    ../common.nix
  ];

  networking.hostName = "nix-desktop";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfree = true;
}
