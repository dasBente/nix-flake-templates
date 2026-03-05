{
  description = "My own templates";

  outputs = {self}: let
    templates = builtins.mapAttrs (name: _: {
      path = ./templates/${name};
      description = let
        flake = import ./templates/${name}/flake.nix;
      in
        flake.description or "${name} template";
    }) (builtins.readDir ./templates);
  in {
    inherit templates;
  };
}
