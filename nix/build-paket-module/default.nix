{ pkgs }:

{ name ? "${args.pname}-${args.version}"

  # The type of build to perform. This is passed to `dotnet` with the `--configuration` flag. Possible values are `Release`, `Debug`, etc.
, buildType ? "Release"
  # The dotnet SDK to use.
, dotnet-sdk ? pkgs.dotnetCorePackages.sdk_7_0

, ... }@args:
let
  package = pkgs.stdenvNoCC.mkDerivation (args // {
    inherit buildType;

    nativeBuildInputs = with pkgs;
      args.nativeBuildInputs or [ ] ++ [ dotnet-sdk cacert makeWrapper ];

    # Stripping breaks the executable
    dontStrip = true;

    # gappsWrapperArgs gets included when wrapping for dotnet, as to avoid double wrapping
    dontWrapGApps = true;

    DOTNET_NOLOGO = true; # This disables the welcome message.
    DOTNET_CLI_TELEMETRY_OPTOUT = true;
  });
in package
