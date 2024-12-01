{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
  };

  outputs = { self, nixpkgs }: {
    default = {
      inputs = self.inputs;
      outputs = { self, nixpkgs }: {
        arguments = {
          buildInputs = pkgs: with pkgs; [
            go
          ];

          src = ./.;

          buildCommand = "go build -o ./scripts/arguments.go";

          package = {
            pname = "arguments";
            installPhase = ''
              mkdir -p $out/bin
              cp -r . $out
            '';
          };
        };
      };
    };
  };
}
