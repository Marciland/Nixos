{ pkgs }:

let
  version = "0.3.5";
  hash = "sha256-wSnz3Hi+hUTwYFXoWMC6Uq9UH0+q0vHoryNwn4t8iMk=";
  cargoHash = "sha256-2ax2yH/dMgXRVNffbl59OTeeMG+v83MnQnsyylrW22s=";
in
pkgs.cargo-leptos.overrideAttrs (oldAttrs: {
  version = version;

  src = pkgs.fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = hash;
  };

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    name = "cargo-leptos-${version}";
    hash = cargoHash;
  };
})
