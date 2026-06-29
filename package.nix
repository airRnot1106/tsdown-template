{
  fetchPnpmDeps,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
  ...
}:
let
  packageJson = builtins.fromJSON (builtins.readFile ./package.json);
  pname = packageJson.name;
  inherit (packageJson) version;
  pnpm = pnpm_10.override { nodejs = nodejs_24; };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = ./.;

  nativeBuildInputs = [
    nodejs_24
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-c5MdvWtwg0lt1CChC3c0Ee7keCMCokIHqdIdXUiFbO4=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm vp run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist $out/
    cp package.json $out/
    runHook postInstall
  '';
})
