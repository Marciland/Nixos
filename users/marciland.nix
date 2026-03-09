{
  users.users.marciland = {
    isNormalUser = true;
    description = "Marcel Witoschek";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # TODO these are still system settings
  programs.git = {
    enable = true;
    config = {
      user.name = "Marcel Witoschek";
      user.email = "marcel.marciland@gmail.com";
      user.signingkey = "/home/marciland/.ssh/github.pub";
      pull.rebase = true;
      fetch.prune = true;
      gpg.format = "ssh";
      commit.gpgsign = true;
    };
  };
}
