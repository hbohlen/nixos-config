# in modules/zfs.nix
{ inputs, pkgs, ... }: # It's good practice to list pkgs here too

{
  # REMOVE THE IMPORTS SECTION FROM THIS FILE
  # imports = [
  #   inputs.disko.nixosModules.disko
  # ];

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
}
