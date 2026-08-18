{
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.default = pkgs.llvmPackages.stdenv.mkDerivation {
      pname = "cpp-template";
      version = "0.0.0";
      src = ../src;
      nativeBuildInputs = [pkgs.cmake];
      buildInputs = []; # libraries here
      cmakeFlags = [];
      meta = with lib; {
        homepage = "";
        description = "Template C++ project";
        license = licenses.mit;
        platforms = with platforms; linux ++ darwin;
        maintainers = [];
      };
    };

    devShells.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        cmake
        catch2
        boost
      ];
    };
  };
}
