{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.workapps;
in {
  options.workapps = {
    enable = mkEnableOption "Work-Necessary Apps";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      kdePackages.kate
      blender
      _1password-gui
      zotero
      ungoogled-chromium
      libresprite
    ];
  };
}
