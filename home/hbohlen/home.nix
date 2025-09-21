# home/hbohlen/home.nix
{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "hbohlen";
  home.homeDirectory = "/home/hbohlen";
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # The packages that should be installed to the user profile.
  home.packages = with pkgs; [
    _1password-gui  # 1Password GUI
    affine  # Affine productivity app
  ];

  # Enable 1Password SSH agent integration
  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    IdentityAgent ~/.1password/agent.sock
  '';

  # Optional: Configure desktop entries for better integration
  xdg.desktopEntries = {
    affine = {
      name = "Affine";
      genericName = "Knowledge Base";
      exec = "affine";
      icon = "affine";
      categories = [ "Office" "Database" ];
    };
  };
}
