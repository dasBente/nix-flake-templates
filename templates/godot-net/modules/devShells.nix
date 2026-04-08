{
  perSystem = {pkgs, ...}: {
    devShells.default = let
      dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          godot-mono
          dotnet-sdk
          mono
          omnisharp-roslyn
          netcoredbg
        ];

        shellHook = let
          libraries = with pkgs; [
            libGL
            libx11
            libxcursor
            libxinerama
            libxi
            libxrandr
          ];
        in ''
          export DOTNET_ROOT="${dotnet-sdk}"
          export PATH="$PATH:$DOTNET_ROOT"
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH"]

          alias godot="godot-mono -e ."

          echo " == Godot Mono Dev Env (.NET $(${dotnet-sdk}/bin/dotnet --version))"
        '';
      };
  };
}
