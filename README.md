# Nix flake templates

Some Nix flake templates I made for myself. To initialize your project from a template, run:

```
nix flake new -t "github:ifd3f/nix-templates#$TEMPLATE_YOU_WANT" $DIR_YOU_WANT
```

## Template actualization

All templates are generated from template-templates in [/generator](./generator). To actualize
them, run the following command in the root directory:

```
nix run .#copy-templates
```

