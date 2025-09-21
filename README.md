You've encountered a few final hurdles, and the log file you provided is perfect for diagnosing them. Let's break down what happened and the correct sequence to fix it.
Analysis of the Errors
You ran into three separate issues, each for a specific reason:
 * passwd: user 'hbohlen' does not exist: This failed because the passwd command was trying to change the password for the user hbohlen in the live USB environment. That user doesn't exist there; it only exists in the configuration you are about to install.
 * mktemp: ... Permission denied: This happened on your first try of nixos-install because the command needs to write files to the /mnt directory, which is owned by the root user. Running it as a regular user doesn't grant it the necessary permissions.
 * error: path '.../hardware-configuration.nix' does not exist: This is the same "chicken-and-egg" problem as before, but at a different stage. It occurred on your second try with sudo nixos-install. This tells us that the nixos-generate-config step was missed or didn't run correctly after disko finished, so the real hardware file was never created.
Corrected Installation Sequence
It seems we missed a step after disko succeeded. Let's combine everything into a final, correct sequence. Please run these commands in this exact order.
1. Prepare and Partition
First, start the shell and clone your repository as before.
nix-shell -p git disko
git clone https://your-git-repo-url/nixos-config.git
cd nixos-config

Next, create the valid dummy file and run disko.
echo "{}" > hosts/desktop/hardware-configuration.nix
disko --mode disko --flake ./#nixos-desktop

2. Generate Hardware Configuration (The Missing Step)
This is the crucial step that was missed. After disko succeeds, you must run this command to generate the real hardware configuration file.
nixos-generate-config --no-filesystems --root /mnt --dir .
mv hardware-configuration.nix hosts/desktop/

3. Set Your Password (The NixOS Way)
Instead of the passwd command, the most reliable method during a fresh install is to edit your hosts/common.nix file and put the actual hashed password in place of the placeholder.
First, generate the hash:
nix-shell -p mkpasswd --run "mkpasswd -m sha-512"

You will be prompted to enter your desired password. It will output a long string starting with $6$. Copy this entire string.
Now, open hosts/common.nix with a text editor (like nano or vim) and replace the placeholder "$6$yourhashedpasswordhere$...." with the string you just copied.
4. Install the System
Finally, run the installation command with sudo.
sudo nixos-install --flake ./#nixos-desktop

This command should now succeed because the real hardware-configuration.nix file exists. Once it finishes, reboot, and your system will be ready.
