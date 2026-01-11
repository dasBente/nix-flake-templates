{
  description = "My own templates";

  outputs = {self}: {
    templates = {
      svelte = {
        path = ./templates/svelte;
        description = "Minimal Svelte with Typescript.";
      };
      cloujre = {
        path = ./templates/clojure;
        description = "Basic Clojure development template.";
      };
      quickshell = {
        path = ./templates/quickshell;
        description = "Quickshell project template.";
      };
    };
  };
}
