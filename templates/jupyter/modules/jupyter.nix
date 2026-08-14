{
  perSystem = {pkgs, ...}: let
    # nixpkgs' jupyterlab wrapper hardcodes JUPYTERLAB_DIR to a literal,
    # unexpanded '$out/share/jupyter/lab', which makes `jupyter lab` look for
    # its frontend assets in "$PWD/$out/share/jupyter/lab". Substitute the real
    # output path; this is a no-op if upstream ever fixes the wrapper.
    python = pkgs.python3.override {
      packageOverrides = self: super: {
        jupyterlab = super.jupyterlab.overrideAttrs (old: {
          postFixup =
            (old.postFixup or "")
            + ''
              sed -i "s|JUPYTERLAB_DIR='\\\$out/share/jupyter/lab'|JUPYTERLAB_DIR='$out/share/jupyter/lab'|" "$out/bin/jupyter-lab"
            '';
        });
      };
    };

    # A Python environment with Jupyter and a starter set of data-science
    # packages. Extend the list (e.g. ps.scikit-learn, ps.torch, ps.plotly)
    # to customize the environment.
    jupyter = python.withPackages (ps: [
      ps.jupyterlab
      ps.notebook
      ps.ipykernel
      ps.numpy
      ps.pandas
      ps.matplotlib
    ]);
  in {
    # `nix develop` drops you into an interactive shell with Jupyter on PATH.
    # Notebooks are an interactive, iterative workflow, so the dev shell is
    # the primary entry point.
    devShells.default = pkgs.mkShell {
      packages = [jupyter];

      shellHook = ''
        echo "Jupyter dev shell ready. Start the notebook server with:"
        echo "  jupyter lab"
      '';
    };

    # `nix run .` starts JupyterLab directly, without entering a shell.
    apps.default = {
      type = "app";
      program = "${pkgs.writeShellScriptBin "jupyter-lab" ''
        exec ${jupyter}/bin/jupyter lab
      ''}/bin/jupyter-lab";
    };
  };
}
