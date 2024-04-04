{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations."DESKTOP-M60QOUU" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/common.nix
        ./hosts/legion/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.minegrub-theme.nixosModules.default
      ];
    };
    nixosConfigurations."DESKTOP-L85FNNQ" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/common.nix
        ./hosts/expertbook/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.minegrub-theme.nixosModules.default
      ];
    };
  };
}
