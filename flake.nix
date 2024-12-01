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
      );

      apps = forAllSystems (system: {
        arguments = {
          type = "app";
          arguments = "${self.packages.${system}.arguments}/bin/arguments";
        };
        default = self.apps.${system}.arguments;
      });
    };
}
