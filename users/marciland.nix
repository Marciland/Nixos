{ pkgs, ... }:

let
  cargo-leptos = import ../packages/cargo-leptos.nix { inherit pkgs; };
  nodejs = import ../packages/nodejs.nix { inherit pkgs; };
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
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    };

    dconf.settings = {
      "org/gnome/gnome-session" = {
        logout-prompt = false;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop"
          "code.desktop"
          "steam.desktop"
          "discord.desktop"
          "spotify.desktop"
          "org.gnome.Console.desktop"
        ];
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 1;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "interactive";
        sleep-inactive-ac-type = "nothing";
        idle-dim = false;
      };
    };

    home.packages = with pkgs; [
      pkg-config
      gcc
      gnumake
      libpq.dev
      rustup
      nodejs
      pnpm
      playwright
      playwright-driver.browsers
      cargo-leptos
      leptosfmt
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
