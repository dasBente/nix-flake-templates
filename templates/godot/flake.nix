{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;}
    (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      systems = ["x86_64-linux"];

      perSystem = {
        self',
        config,
        pkgs,
        ...
      }: {
        packages.godot-wrapped = pkgs.writeShellScriptBin "godot" ''
          exec ${pkgs.godot-mono}/bin/godot-mono -e . "$@" > /dev/null
        '';

        devShells.default = pkgs.mkShell {
          packages = [
            config.packages.godot-wrapped
          ];
          nativeBuildInputs = with pkgs; [
            mono
            godot-mono
          ];
        };
      };
    });
}
