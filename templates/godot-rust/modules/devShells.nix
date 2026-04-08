{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        cargo
        rustc
        rustfmt
        rustPackages.clippy
        godot
      ];

      RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
    };
  };
}
