{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # This will be generated during installation
    ../common.nix
  ];
  boot.loader.systemd-boot.enable = true;
  
  fileSystems."/persist".neededForBoot = true;
  networking.hostName = "nix-desktop";
  hardware.nvidia.open = false;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-remote-desktop.enable = false;


  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire.enable = false;
  services.pipewire.pulse.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfree = true;
}
