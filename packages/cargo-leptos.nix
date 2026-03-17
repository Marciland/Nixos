{ pkgs }:

let
  version = "0.3.1";
  hash = "sha256-vQZpw0hnBQRXmt4KsThcVwLtRwSpbjaGfojCIgfOn7E=";
  cargoHash = "sha256-WlzkTZHWDkE2rhH+fi8+aa/mkjBEVwQK8cTxd2JUuZ8=";
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
