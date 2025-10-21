{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "renn-es";
          version = "0.0.1";
          src = ./.;
          builder = ./builder.sh;
          buildInputs = with pkgs; [
            typst
          ];
        };
        apps.deploy = {
          type = "app";
          program = let
            script = pkgs.writeShellApplication {
              name = "dev";
              runtimeInputs = with pkgs; [
                rsync
              ];
              text = ''
                nix build
                rsync -avx --delete result/ admin@ssh.renn.es:textes.renn.es/
              '';
            };
          in
            "${script}/bin/dev";
        };
      }
    );
}
