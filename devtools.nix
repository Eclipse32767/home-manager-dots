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
    cpp.enable = mkEnableOption "C++ Utilities";
    rust.enable = mkEnableOption "Rust Utilities";
    haskell.enable = mkEnableOption "Haskell Utilities";
    zig.enable = mkEnableOption "Zig Utilities";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zed-editor
      (mkIf
        cfg.cpp.enable
        clang)
      (
        mkIf
        cfg.rust.enable
        (rust-bin.selectLatestNightlyWith (toolchain: toolchain.default))
      )
      (mkIf
        cfg.haskell.enable
        ghc)
      (mkIf
        cfg.rust.enable
        jetbrains.rust-rover)
      (mkIf
        cfg.zig.enable
        zig)
      mdbook
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
