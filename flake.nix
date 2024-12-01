{
  description = "JavaScript scripts using Bun runtime";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

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
  
        in
        {
          default = arguments;
        }
      );

      apps = forAllSystems (system: {
        arguments = {
          type = "app";
          program = "${self.packages.${system}.arguments}/bin/arguments";
        };
        default = self.apps.${system}.arguments;
      });
    };
}
