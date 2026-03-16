{ pkgs }:

pkgs.cargo-leptos.overrideAttrs (oldAttrs: rec {
  version = "0.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = "sha256-vQZpw0hnBQRXmt4KsThcVwLtRwSpbjaGfojCIgfOn7E=";
  };

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    inherit src;
    name = "cargo-leptos-${version}";
    hash = "sha256-WlzkTZHWDkE2rhH+fi8+aa/mkjBEVwQK8cTxd2JUuZ8=";
  };
})
