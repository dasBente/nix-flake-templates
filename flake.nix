{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      let
        # list of all template directories
        template-dirs = builtins.readDir ./templates;

        # list of flake-style template outputs
        templates =
          builtins.mapAttrs (name: _: {
            path = ./templates/${name};
            description = let
              flake = import ./templates/${name}/flake.nix {};
            in
              flake.description or "template: ${name}";
          })
          template-dirs;
      in {
        systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
        flake = {
          inherit templates;
        };

        perSystem = {pkgs, ...}: {
          packages.default = pkgs.writeShellScriptBin "init-template" ''
            set -e

            templates="${builtins.concatStringsSep "\n" (builtins.attrNames template-dirs)}"
            selected=$(echo "$templates" | ${pkgs.fzf}/bin/fzf)

            if [ -z "$selected" ]; then
                echo "No template selected"
                exit 1
            fi

            echo "Initializing template: $selected"
            nix flake init -t "github:dasbente/nix-flake-templates#$selected"
          '';
        };
      }
    );
}
