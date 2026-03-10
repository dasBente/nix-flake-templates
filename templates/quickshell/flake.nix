{
  description = "Basic quickshell project with hello-world sample app.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      top @ {
        config,
        withSystem,
        moduleWithSystem,
        ...
      }: {
        imports = [];

        systems = ["x86_64-linux"];

        perSystem = {
          config,
          pkgs,
          system,
          ...
        }: let
          mkQuickShell = opts:
            pkgs.stdenv.mkDerivation {
              inherit (opts) name src;

              nativeBuildInputs = [pkgs.qt6.wrapQtAppsHook];
              buildInputs = [pkgs.quickshell pkgs.qt6.qtbase];

              installPhase = ''
                runHook preInstall

                mkdir -p $out/share/${opts.name}
                cp -r . $out/share/${opts.name}/

                makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/${opts.name} \
                  --prefix QML2_IMPORT_PATH : "$out/share/${opts.name}" \
                  --add-flags "--path $out/share/${opts.name}/shell.qml"

                runHook postInstall
              '';
            };
        in {
          packages.default = mkQuickShell {
            name = "quickshell-hello-world";
            src = ./hello-world;
          };

          devShells.default = pkgs.mkShell {
            packages = [pkgs.quickshell];
          };
        };
      }
    );
}
