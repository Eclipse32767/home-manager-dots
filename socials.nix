{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.socials;
in {
  options.socials = {
    discord = {
      enable = mkEnableOption "Discord";
      client = mkPackageOption pkgs "discord" {
        nullable = false;
      };
    };
    mastodon = {
      enable = mkEnableOption "Mastodon";
      client = mkPackageOption pkgs.kdePackages "tokodon" {
        nullable = false;
      };
    };
  };
  config = {
    home.packages = with pkgs; [
      (mkIf
        cfg.discord.enable
        cfg.discord.client)
      (mkIf
        cfg.mastodon.enable
        cfg.mastodon.client)
    ];
  };
}
