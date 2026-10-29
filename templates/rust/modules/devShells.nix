{
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        cargo
        rustc
        rustfmt
        pre-commit
        rustPackages.clippy
      ];

      RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

      packages = [
        (pkgs.writeShellScriptBin "editor" ''
          exec ${inputs'.portable-nvim.packages.rust}/bin/nvim "$@"
        '')
      ];
    };
  };
}
