{
  description = "Convert Paket dependencies to a Nix derivation";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = inputs@{ self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems
        (system: let pkgs = nixpkgsFor.${system}; in { default = { }; });

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = with pkgs;
            mkShell { packages = [ dotnetCorePackages.sdk_6_0 ]; };
        });
    };
}
