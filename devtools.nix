{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.devtools;
in {
  options.devtools = {
    enable = mkEnableOption "Devtools";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clang
      zed-editor
      rustup
      ghc
      mdbook
      jetbrains.rust-rover
    ];
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-cmp
        cmp_luasnip
        cmp-nvim-lsp
      ];
    };
  };
}
