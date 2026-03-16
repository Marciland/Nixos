{ pkgs, ... }:
let
  cargo-leptos = import ../packages/cargo-leptos.nix { inherit pkgs; };
in
{
  users.users.marciland = {
    isNormalUser = true;
    description = "Marcel Witoschek";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager.users.marciland = {
    home.stateVersion = "25.11";

    programs.bash.enable = true;

    home.sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.libpq.dev}/lib/pkgconfig";
    };

    home.packages = with pkgs; [
      pkg-config
      gcc
      gnumake
      libpq.dev
      rustup
      leptosfmt
      cargo-leptos
      pnpm
      cargo-llvm-cov
      cargo-nextest
    ];

    programs.git = {
      enable = true;
      signing.key = "/home/marciland/.ssh/github.pub";
      settings = {
        user.name = "Marcel Witoschek";
        user.email = "marcel.marciland@gmail.com";
        core.editor = "code --wait";
        pull.rebase = true;
        fetch.prune = true;
        gpg.format = "ssh";
      };
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "/home/marciland/.ssh/github";
          identitiesOnly = true;
        };
      };
    };
  };
}
