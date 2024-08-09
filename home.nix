{
  pkgs,
  lib,
  ...
}: let
  colors = {
    base00 = "24283B";
    base01 = "16161E";
    base02 = "343A52";
    base03 = "444B6A";
    base04 = "787C99";
    base05 = "A9B1D6";
    base06 = "CBCCD1";
    base07 = "D5D6DB";
    base08 = "C0CAF5";
    base09 = "A9B1D6";
    base0A = "0DB9D7";
    base0B = "9ECE6A";
    base0C = "B4F9F8";
    base0D = "2AC3DE";
    base0E = "BB9AF7";
    base0F = "F7768E";
  };
in {
  home.username = "kit";
  home.homeDirectory = "/home/kit";
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./zsh.nix
    ./workapps.nix
    ./playapps.nix
    ./devtools.nix
    ./rivercfg.nix
    ./socials.nix
  ];
  workapps.enable = true;
  playapps.enable = true;
  devtools.enable = true;
  socials.discord.enable = true;
  socials.discord.client = pkgs.webcord;
  socials.mastodon.enable = true;
  rivercfg.enable = true;
  rivercfg.colors = colors;
  stylix.enable = true;
  stylix.image = ./wpaper.jpg;
  stylix.base16Scheme = colors;
  stylix.targets.waybar.enable = false;
  stylix.targets.gtk.extraCss = ''
        /* No (default) title bar on wayland */
    headerbar.default-decoration {
      /* You may need to tweak these values depending on your GTK theme */
      margin-bottom: 50px;
      margin-top: -100px;
    }

    /* rm -rf window shadows */
    window.csd,             /* gtk4? */
    window.csd decoration { /* gtk3 */
      box-shadow: none;
    }
  '';
  stylix.cursor.package = pkgs.kdePackages.breeze;
  stylix.cursor.name = "breeze_cursors";
  stylix.fonts = let
    allfonts = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts;
    };
  in {
    monospace = allfonts;
    sansSerif = allfonts;
    serif = allfonts;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
