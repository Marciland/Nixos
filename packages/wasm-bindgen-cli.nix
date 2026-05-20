{ pkgs }:

let
  version = "0.2.121";

  src = pkgs.fetchCrate {
    pname = "wasm-bindgen-cli";
    inherit version;
    hash = "sha256-ZOMgFNOcGkO66Jz/Z83eoIu+DIzo3Z/vq6Z5g6BDY/w=";
  };
in
pkgs.wasm-bindgen-cli.overrideAttrs (_oldAttrs: {
  inherit version src;

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    name = "wasm-bindgen-cli-${version}";
    inherit src;
    hash = "sha256-DPdCDPTAPBrbqLUqnCwQu1dePs9lGg85JCJOCIr9qjU=";
  };
})
