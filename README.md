# Nixos

```sh
sudo nixos-rebuild test --flake --impure
```

## Hashes

```
nix-prefetch-url --type sha256 --unpack <githubURL to .tar.gz>
nix hash convert --hash-algo sha256 --to sri <hash from above>
```
