{
  description = "Basic setup for Clojure development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
  utils.lib.eachDefaultSystem (system:
    let
      javaVersion = 23;
      jdk = "jdk${toString javaVersion}";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            jdk = super."${jdk}";
            clojure = super.clojure.override {
              jdk = super."${jdk}";
            };
            # lein = super.clojure.override { jdk = super."${jdk}"; };
          })
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          clojure
          openjdk11
        ];
      };
    }
  );
}
