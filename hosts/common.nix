# hosts/common.nix
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

  # Enable Flatpak for applications not available in nixpkgs
  services.flatpak.enable = true;

  # Define your user account.
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "wheel" "networkmanager" ];
    # Replace this with your actual password hash
    hashedPassword = "$6$your-password-hash-here";
  };

  # List system-wide packages (available to all users)
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    podman
    vivaldi  # Web browser - system-wide installation
  ];

  # 1Password setup - required for the GUI to work properly
  security.wrappers.1password = {
    owner = "root";
    group = "root";
    capabilities = "cap_ipc_lock+ep";
    source = "${pkgs._1password-gui}/bin/1password";
  };

  # Basic Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.05";
}
