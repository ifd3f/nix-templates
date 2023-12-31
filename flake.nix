{
  description = "ifd3f templates";

  outputs = { self, nixpkgs, ... }:
    let
      # Use this instead of flake-utils to avoid any dependencies at all
      # in this templates-only flake
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);

      lib = nixpkgs.lib;
      actualizedDir = "actualized";
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          generated = pkgs.callPackage ./generator/templates.nix { };
        in ({
          copy-templates = pkgs.writeScriptBin "copy-templates" ''
            set -euxo pipefail

            rm -rf ${actualizedDir}/*
            mkdir -p ${actualizedDir}

            cp -rT ${generated.haskell} ${actualizedDir}/haskell
            cp -rT ${generated.rust} ${actualizedDir}/rust
            cp -rT ${generated.python} ${actualizedDir}/python

            chmod +w -R ${actualizedDir}
          '';
        }) // generated);

      templates = {
        haskell = {
          path = "${./.}/${actualizedDir}/haskell";
          description = "Haskell with package.yaml";
        };

        rust = {
          path = "${./.}/${actualizedDir}/rust";
          description = "Rust";
          welcomeText = ''
            To initialize the Rust template, run the following command in the root dir:

            $ nix run nixpkgs#cargo -- init
          '';
        };

        python = {
          path = "${./.}/${actualizedDir}/python";
          description = "Python";
          welcomeText = ''
            To initialize the Python template, run the following command in the root dir:

            $ nix run nixpkgs#poetry -- init
          '';
        };
      };
    };
}
