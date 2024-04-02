{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";

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
    nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/legion/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.minegrub-theme.nixosModules.default
      ];
    };
    nixosConfigurations.expertbook = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/expertbook/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.minegrub-theme.nixosModules.default
      ];
    };
  };
}
