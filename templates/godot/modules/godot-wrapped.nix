{
  perSystem = {pkgs, ...}: {
    packages.godot-wrapped = pkgs.writeShellScriptBin "godot" ''
      exec ${pkgs.godot-mono}/bin/godot-mono -e . "$@" > /dev/null
    '';
  };
}
