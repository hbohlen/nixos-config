Here are the installation steps to be run in the terminal after you boot into the NixOS live ISO.

-----

## 1\. Prepare the Environment

First, open a terminal and enter a shell with the necessary tools.

```bash
nix-shell -p nixos-install-tools git disko
```

Then, clone your configuration repository from GitHub.

```bash
git clone https://github.com/hbohlen/nixos-config.git
cd nixos-config
```

-----

## 2\. Partition the Disk

This command will wipe `/dev/nvme1n1` and apply the ZFS layout defined in your `modules/zfs.nix` file. **This is a destructive operation.**

```bash
disko --mode disko ./#nix-desktop
```

-----

## 3\. Generate Final Configuration

Now, generate the hardware-specific configuration and move it to the correct directory within your cloned repository.

```bash
nixos-generate-config --no-filesystems --root /mnt --dir .
mv hardware-configuration.nix hosts/desktop/
```

Next, set your user password. You'll be prompted to enter and confirm it.

```bash
nix-shell -p mkpasswd --run "passwd hbohlen"
```

-----

## 4\. Install the System

Finally, run the NixOS installer, pointing it to your local flake configuration for the desktop. This will build and install your entire system.

```bash
nixos-install --flake ./#nix-desktop
```

Once the installation is complete, reboot the machine.

```bash
reboot
```
