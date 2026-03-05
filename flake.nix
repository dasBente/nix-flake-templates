{
  description = "My own templates";

  outputs = {self}: {
    templates = {
      svelte = {
        path = ./templates/svelte;
        description = "Minimal Svelte with Typescript.";
      };
      quickshell = {
        path = ./templates/quickshell;
        description = "Quickshell project template.";
      };
      flake-parts = {
        path = ./templates/flake-parts;
        description = "Empty flake using flake-parts and dendritic modules";
      };
    };
  };
}
