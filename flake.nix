{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    oldpkgs.url = "github:nixos/nixpkgs/6143fc5eeb9c4f00163267708e26191d1e918932";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    oldpkgs,
    rust-overlay,
    home-manager,
    stylix,
  }: {
    homeConfigurations.kit = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          (final: prev: {
            #xwayland = oldpkgs.legacyPackages."x86_64-linux".xwayland;
            waybar = nixpkgs.legacyPackages."x86_64-linux".waybar.override {hyprlandSupport = false;};
          })
          rust-overlay.overlays.default
        ];
      };
      modules = [
        stylix.homeManagerModules.stylix
        ./home.nix
      ];
    };
  };
}
