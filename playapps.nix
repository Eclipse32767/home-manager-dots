{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.playapps;
in {
  options.playapps = {
    enable = mkEnableOption "Games and Emulators";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dolphin-emu
      cemu
      prismlauncher
    ];
  };
}
