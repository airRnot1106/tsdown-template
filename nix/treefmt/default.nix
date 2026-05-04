{ pkgs, treefmt-nix }:
treefmt-nix.lib.evalModule pkgs {
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
  };
  settings.formatter = {
    vp-fmt = {
      command = "pnpm";
      options = [
        "vp"
        "fmt"
      ];
      includes = [
        "*.ts"
        "*.tsx"
        "*.js"
        "*.jsx"
        "*.json"
        "*.yaml"
        "*.yml"
        "*.md"
      ];
    };
  };
}
