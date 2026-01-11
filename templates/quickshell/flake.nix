{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        flake = {
        };

        flake = {};

        systems = ["x86_64-linux"];

        perSystem = {
          config,
          pkgs,
          system,
          ...
        }: let
          quickshell = inputs.quickshell.packages.${system}.default;
        in {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "quickshell-hello-world";
            version = "1.0";
            src = ./hello-world;

            nativeBuildInputs = [pkgs.qt6.wrapQtAppsHook];
            buildInputs = [quickshell pkgs.qt6.qtbase];

            installPhase = ''
              mkdir -p $out/share/hello-world
              cp shell.qml $out/share/hello-world

              makeWrapper ${quickshell}/bin/quickshell $out/bin/quickshell-hello-world \
                --add-flags "--path $out/share/hello-world/shell.qml"
            '';
          };
        };
      }
    );
}
