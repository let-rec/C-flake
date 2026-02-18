flake:
{ pkgs, ... }:
pkgs.mkShell {
  # Upstream environments
  inputsFrom = [ flake.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # Extra packages to include
  packages = with pkgs; [
    # Nix
    nixd
    nixfmt
    statix
    deadnix

    # Extra
    just
  ];
}
