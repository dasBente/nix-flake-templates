{
  description = "My own templates";

  outputs = { self }: {
    templates = {
      svelte = {
        path = ./templates/svelte;
        description = "Minimal Svelte with Typescript";
      };
    };
  };
}
