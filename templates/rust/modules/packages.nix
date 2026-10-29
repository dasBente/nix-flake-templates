{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    naersk-lib = pkgs.callPackage "${inputs.naersk}/default.nix" {};
  in {
    packages.default = naersk-lib.buildPackage ../.;
  };
}
