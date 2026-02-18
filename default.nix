{
  pkgs ? import <nixpkgs> { },
}:
let
  lib = pkgs.lib;
in
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "c-flake";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    cmake
    llvmPackages.llvm
    llvmPackages.clang-tools
  ];

  cmakeFlags = [
    "-DENABLE_TESTING=OFF"
    "-DENABLE_INSTALL=ON"
  ];

  meta = with lib; {
    homepage = "c-flake";
    licencse = licenses.wtfpl;
    platforms = with platforms; linux ++ darwin;
  };
}
