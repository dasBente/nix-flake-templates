{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.rust = let
      naersk-lib = pkgs.callPackage inputs.naersk {};
    in
      naersk-lib.buildPackage {
        src = ../rust;
        copyLibs = true;
      };
  };
}
