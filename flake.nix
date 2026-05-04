{
  inputs = {
    agent-skills = {
      url = "path:./nix/agent-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      agent-skills,
      git-hooks,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forEachSystem = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            (_: prev: {
              pnpm = prev.pnpm_10.override { nodejs = prev.nodejs_24; };
            })
          ];
        };
      treefmtEval =
        system:
        import ./nix/treefmt {
          pkgs = pkgsFor system;
          inherit treefmt-nix;
        };
      preCommitCheck =
        system:
        import ./nix/pre-commit {
          pkgs = pkgsFor system;
          inherit git-hooks self system;
          src = ./.;
        };
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = pkgsFor system;
          preCommit = preCommitCheck system;
        in
        {
          default = pkgs.mkShellNoCC {
            inputsFrom = [ agent-skills.devShells.${system}.default ];
            inherit (preCommit) shellHook;
            packages =
              preCommit.enabledPackages
              ++ (with pkgs; [
                git
                nodejs_24
                pnpm
                uv
              ]);
          };
        }
      );
      formatter = forEachSystem (system: (treefmtEval system).config.build.wrapper);
      checks = forEachSystem (system: {
        pre-commit = (preCommitCheck system).check;
      });
      packages = forEachSystem (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.callPackage ./package.nix { };
        }
      );
    };
}
