{ runCommand, nixfmt }:
let
  appendGitignore = "cat ${./common/common.gitignore} >> $out/.gitignore";
  addCIWorkflow = "mkdir -p $out/common/.github/workflows && cp ${
      ./common/workflows/ci.yml
    } $out/common/.github/workflows/ci.yml";
  addEnvrc = "cp ${./common/common.envrc} $out/.envrc";
  fullNixfmt = "nixfmt $out/**/*.nix";

  makeTemplate = { name, src, buildInputs ? [ ], extraScript ? "" }:
    runCommand name {
      inherit src;
      common = ./common;
      buildInputs = [ nixfmt ] ++ buildInputs;
    } ''
      shopt -s globstar
      set -euxo pipefail

      mkdir -p $out
      cp -rT $src $out
      chmod -R +w $out

      cat $common/common.gitignore >> $out/.gitignore

      mkdir -p $out/.github/workflows
      cp $common/workflows/ci.yml $out/.github/workflows/ci.yml

      cp $common/common.envrc $out/.envrc

      nixfmt $out/**/*.nix

      ${extraScript}
    '';

in {
  haskell = makeTemplate {
    name = "haskell-template";
    src = ./haskell;
  };

  rust = makeTemplate {
    name = "rust";
    src = ./rust;
  };

  python = makeTemplate {
    name = "rust";
    src = ./rust;
  };
}
