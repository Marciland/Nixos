{ pkgs, inputs, ... }:

let
  scripts = ../scripts;
  wasm-bindgen-cli = import ../packages/wasm-bindgen-cli.nix { inherit pkgs; };
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

  home-manager.users.marciland =
    { lib, ... }:
    {
      home.stateVersion = "25.11";

      home.activation = {
        rustSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PATH="${
            lib.makeBinPath [
              pkgs.rustup
              pkgs.coreutils
            ]
          }" ${pkgs.bash}/bin/bash ${scripts}/rust-setup.sh
        '';
      };

      programs.bash = {
        enable = true;
        initExtra = ''
          if ! rustup show active-toolchain >/dev/null 2>&1; then
            rustup default 1.87.0 >/dev/null 2>&1
          fi
        '';
      };

      home.sessionVariables = {
        PKG_CONFIG_PATH = "${pkgs.libpq.dev}/lib/pkgconfig";

        PW_TEST_CONNECT_WS_ENDPOINT = "ws://127.0.0.1:9323/";
        WEBSITE_PORT = 6300;
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
        wasm-bindgen-cli
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
        settings = {
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
