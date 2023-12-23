{
  # inspired by: https://serokell.io/blog/practical-nix-flakes#packaging-existing-applications
  description = "A Hello World in Haskell with a dependency and a devShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
          haskell-hello =
            pkgs.haskellPackages.callCabal2nix "haskell-hello" ./. { };
          default = self.packages.${system}.haskell-hello;
        };

        checks = self.packages.${system};

        devShells.default = pkgs.haskellPackages.shellFor {
          packages = p: [ self.packages.${system}.haskell-hello ];
          withHoogle = true;
          buildInputs = with pkgs.haskellPackages; [
            haskell-language-server
            ghcid
            cabal-install
          ];
        };
      });
}
