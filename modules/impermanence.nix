# in modules/impermanence.nix
{ inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # The root filesystem is a temporary, in-memory filesystem.
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  # The persistence module defines what to save across reboots.
  environment.persistence."/persist" = {
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/etc/nixos" # Your flake config must persist!
      { directory = "/var/lib/containers"; user = "root"; group = "root"; mode = "0755"; }
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
