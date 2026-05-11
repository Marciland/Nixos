{ pkgs }:

let
  version = "0.2.114";

  src = pkgs.fetchCrate {
    pname = "wasm-bindgen-cli";
    inherit version;
    hash = "sha256-xrCym+rFY6EUQFWyWl6OPA+LtftpUAE5pIaElAIVqW0=";
  };
in
pkgs.wasm-bindgen-cli.overrideAttrs (_oldAttrs: {
  inherit version src;

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    name = "wasm-bindgen-cli-${version}";
    inherit src;
    hash = "sha256-Z8+dUXPQq7S+Q7DWNr2Y9d8GMuEdSnq00quUR0wDNPM=";
  };
})
