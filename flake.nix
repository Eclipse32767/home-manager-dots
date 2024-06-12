{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
  }: {
    homeConfigurations.kit = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {system = "x86_64-linux";};
      modules = [
        stylix.homeManagerModules.stylix
        ./home.nix
      ];
    };
  };
}
