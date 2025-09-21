# in modules/zfs.nix
{ inputs, ... }:

{
  # This line is the fix. It imports the official Disko module,
  # which makes the 'disko.devices' option available.
  imports = [
    inputs.disko.nixosModules.disko
  ];

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
          "root" = { type = "zfs_fs"; mountpoint = "/"; };
          "nix" = { type = "zfs_fs"; mountpoint = "/nix"; };
          "home" = { type = "zfs_fs"; mountpoint = "/home"; };
          "persist" = { type = "zfs_fs"; mountpoint = "/persist"; };
          "var_log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "false";
          };
          "containers" = { type = "zfs_fs"; mountpoint = "/var/lib/containers"; };
        };
      };
    };
  };
}
