{ runCommand, nixfmt }: {
  haskell = runCommand "haskell-template" { buildInputs = [ nixfmt ]; } ''
    shopt -s globstar

    mkdir -p $out
    cp -rT ${./haskell} $out
    chmod -R +w $out
    nixfmt $out/**/*.nix
    cat ${./common/common.gitignore} >> $out/.gitignore
  '';
}
