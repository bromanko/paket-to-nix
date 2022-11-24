{
  description = "Convert Paket dependencies to a Nix derivation";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = inputs@{ self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      buildPaketModule = pkgs:
        import ./nix/build-paket-module { inherit pkgs; };

    in {
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = buildPaketModule pkgs {
            pname = "paket-to-nix";
            version = "0.0.1";
          };
        });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = with pkgs;
            mkShell { packages = [ dotnetCorePackages.sdk_6_0 ]; };
        });
    };
}
