{
  description = "cargo-leptos";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      defaultPackage.x86_64-linux =
        import nixpkgs
          {
            system = "x86_64-linux";
          }
          .cargo-leptos.override
          { version = "0.3.0"; };
    };
}
