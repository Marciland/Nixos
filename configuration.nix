{ pkgs, inputs, ... }:

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
  };
  security.rtkit.enable = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    liquidctl # sudo liquidctl --match kraken set lcd screen orientation 90
    nixfmt
    vscode
    discord
    spotify
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "btrfs";
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  system.stateVersion = "25.11";
}
