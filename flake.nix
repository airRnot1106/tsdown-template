{
  inputs = {
    agent-skills = {
      url = "path:./nix/agent-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      agent-skills,
      nixpkgs,
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
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShellNoCC {
            inputsFrom = [ agent-skills.devShells.${system}.default ];
            packages = with pkgs; [
              actionlint
              corepack_24
              ghalint
              git
              gitleaks
              nodejs-slim_24
              pinact
              uv
            ];
          };
        }
      );
      formatter = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixfmt-tree
      );
      checks = forEachSystem (
        system:
        let
          package = self.packages.${system}.default;
        in
        {
          vp-check = package.overrideAttrs (_: {
            pname = "vp-check";
            buildPhase = ''
              runHook preBuild
              pnpm vp check
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              touch $out
              runHook postInstall
            '';
          });
        }
      );
      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./package.nix { };
        }
      );
    };
}
