{
  self,
  git-hooks,
  pkgs,
  src,
  system,
}:
let
  inherit (pkgs.lib) getExe;
  basePreCommit = git-hooks.lib.${system}.run {
    inherit src;
    hooks = {
      actionlint.enable = true;
      ghalint = rec {
        enable = true;
        package = pkgs.ghalint;
        entry = "${getExe package} run";
        files = "^\\.github/workflows/.*\\.ya?ml$";
        pass_filenames = false;
      };
      ghalint-action = rec {
        enable = true;
        package = pkgs.ghalint;
        entry = "${getExe package} act";
        files = "^\\.github/actions/.*/action\\.ya?ml$";
        pass_filenames = true;
      };
      gitleaks = rec {
        enable = true;
        package = pkgs.gitleaks;
        entry = "${getExe package} git --pre-commit --redact --staged --verbose";
        pass_filenames = false;
      };
      pinact = rec {
        enable = true;
        package = pkgs.pinact;
        entry = "${getExe package} run -u --min-age 7";
        files = "^\\.github/workflows/.*\\.ya?ml$";
        pass_filenames = true;
      };
      treefmt = {
        enable = true;
        package = self.formatter.${system};
      };
      vp-check = {
        enable = true;
        name = "vp check";
        entry = "pnpm vp check --fix";
        pass_filenames = true;
      };
    };
  };
in
{
  inherit (basePreCommit) shellHook enabledPackages;
  check = basePreCommit.overrideAttrs (old: {
    nativeBuildInputs =
      (old.nativeBuildInputs or [ ])
      ++ (with pkgs; [
        nodejs_24
        pnpm
        pnpmConfigHook
      ]);
    inherit (self.packages.${system}.default) pnpmDeps;
  });
}
