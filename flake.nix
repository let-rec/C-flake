{
  description = "C fucked and flaked";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      flake-parts,
      self,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          packages.default = pkgs.callPackage ./. { };

          devShells.default = import ./shell.nix self { inherit pkgs; };
        };
    };
}
