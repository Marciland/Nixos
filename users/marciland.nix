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

    packages = with pkgs; [
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
    ];
  };

  home-manager.users.marciland = {
    home.stateVersion = "25.11";

    programs.bash.enable = true;

    home.sessionVariables = {
      WINEARCH = "win64";
      WINEPREFIX = "$HOME/.wine-battlenet";

      PKG_CONFIG_PATH = "${pkgs.libpq.dev}/lib/pkgconfig";

      PW_TEST_CONNECT_WS_ENDPOINT = "ws://127.0.0.1:9323/";
      FRONTEND_PORT = 6300;
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

      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        color-scheme = "prefer-dark";
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/map-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/map-d.svg";
      };

      "org/gnome/desktop/screensaver" = {
        lock-enabled = false;
        idle-activation-enabled = false;
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
      binaryen
      libpq.dev
      dotnet-sdk_10
      rustup
      cloc
      nodejs
      pnpm
      git-lfs
      cargo-leptos
      leptosfmt
      cargo-llvm-cov
      cargo-nextest
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
      signing = {
        signByDefault = true;
        key = "~/.ssh/github.pub";
      };
      settings = {
        user.name = "Marcel Witoschek";
        user.email = "marcel.marciland@gmail.com";
        core.editor = "code --wait";
        pull.rebase = true;
        fetch.prune = true;
        gpg.format = "ssh";
        advice.detachedHead = false;
      };
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/home/marciland/.ssh/github";
          identitiesOnly = true;
        };
        "10.10.0.2" = {
          hostname = "10.10.0.2";
          user = "root";
          identityFile = "/home/marciland/.ssh/raspi";
          identitiesOnly = true;
        };
      };
    };
  };
}
