{
  pkgs,
  lib,
  ...
}: let
  colors = builtins.fromJSON (builtins.readFile ./theme.json);
in {
  home.username = "kit";
  home.homeDirectory = "/home/kit";
  home.packages = with pkgs; [
    ncurses
    ncurses.dev
  ];
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
  devtools.cpp.enable = true;
  devtools.rust.enable = true;
  devtools.haskell.enable = true;
  devtools.zig.enable = true;
  socials.discord.enable = true;
  socials.discord.client = pkgs.vesktop;
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
