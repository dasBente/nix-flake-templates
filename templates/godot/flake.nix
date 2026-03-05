{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        self',
        pkgs,
        ...
      }: {
        packages.godot-wrapped = pkgs.writeShellScriptBin "godot" ''
          exec ${pkgs.godot-mono}/bin/godot-mono -e . "$@" > /dev/null
        '';

        devShells.default = pkgs.mkShell {
          packages = [self'.packages.godot-wrapped];
          nativeBuildInputs = with pkgs; [
            mono
            godot-mono
          ];
        };
      };
    };
}
