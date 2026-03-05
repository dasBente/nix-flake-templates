{
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [self'.packages.godot-wrapped];
      nativeBuildInputs = with pkgs; [
        mono
        godot-mono
      ];
    };
  };
}
