{
  description = "The Sensei dev flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              erlang
            ];
          };
        };
    };
}
