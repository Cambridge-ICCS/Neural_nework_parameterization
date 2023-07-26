{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
   flake-utils.lib.eachDefaultSystem (system:
     let
       pkgs = import nixpkgs {
         inherit system;
         #config = { allowUnfree = true; };
       };
     in {
       packages.default = pkgs.stdenv.mkDerivation {
         name = "samson";
         src = ./.;
         #inherit system name src;
         nativeBuildInputs = with pkgs; [
           cmake
           pkgconf
           gfortran
           mpi
           netcdf netcdffortran
         ];
         buildInputs = with pkgs; [
           netcdf netcdffortran
         ];
         patches = [ ./cmake-gfortran.patch ];
         installPhase = ''
           mkdir -p $out/bin
           install -m755 main $out/bin/samson
         '';
       };
     });
}
