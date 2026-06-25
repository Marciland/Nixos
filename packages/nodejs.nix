{ pkgs }:

let
  version = "26.0.0";
  hash = "sha256-NF1VhRTGJiK1x9H3tfKhnDGrFAXSF99J8BDF6o3swPQ=";
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
