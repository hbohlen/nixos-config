# in hosts/common.nix
{ pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable ZFS support.
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "cafebabe";

  # Enable the SSH daemon.
  services.sshd.enable = true;

  # Define your user account.
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$1321$....";
  };

  # List packages you want to install on all systems.
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    podman
  ];

  # Basic Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
}
