{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./users
    ./programs
  ];

  boot.loader = {
    timeout = 0;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  services = {
    desktopManager.gnome.enable = true;
    gnome.gnome-settings-daemon.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    github-runners = {
      marciland = {
        enable = true;
        package = unstable.github-runner;
        name = "marciland";
        user = "marciland";
        group = "docker";
        tokenFile = "/home/marciland/.secrets/github-token";
        url = "https://github.com/Marciland/marciland.net";
        extraPackages = with pkgs; [
          bash
          curl
          git
          git-lfs
          glibc.bin
          jq
          gcc
          binutils
          gnumake
          perl
          pkg-config
          openssl
          libpq.dev
          coreutils
          findutils
          gnugrep
          gnused
          gawk
          gnutar
          gzip
          unzip
          xz
          zstd
          cacert
          rustup
          binaryen
          nodejs
          pnpm
          cargo-leptos
          wasm-bindgen-cli
          leptosfmt
          docker
          gnupg
        ];

        extraEnvironment = {
          PKG_CONFIG_PATH = "${pkgs.libpq.dev}/lib/pkgconfig";
        };
      };
    };
  };
  security.rtkit.enable = true;

  programs.nix-ld.enable = true;

  environment = {
    systemPackages = with pkgs; [
      liquidctl # sudo liquidctl --match kraken set lcd screen orientation 90
      nixfmt
      vscode
      discord
      spotify
    ];

    gnome.excludePackages = with pkgs; [
      baobab
      decibels
      epiphany
      geary
      loupe
      papers
      showtime
      simple-scan
      snapshot
      totem
      yelp
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-connections
      gnome-contacts
      gnome-clocks
      gnome-disk-utility
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-text-editor
      gnome-tour
      gnome-weather
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  system.stateVersion = "25.11";
}
