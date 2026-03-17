{ pkgs }:

let
  version = "22.22.1";
  hash = "sha256-mmvIL5tJEnkUchn2oYrdHhhCTc6Q1B0qX81p1JJLo6o=";
in
pkgs.stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = pkgs.fetchurl {
    url = "https://nodejs.org/dist/v${version}/node-v${version}-linux-x64.tar.xz";
    hash = hash;
  };

  installPhase = ''
    mkdir -p $out
    cp -r bin lib include share $out/
  '';
}
