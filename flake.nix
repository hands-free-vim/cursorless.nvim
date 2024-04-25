{
  description = "A cursorless.nvim dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              pre-commit
              # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
              bashInteractive
              stylua
              lua51Packages.luacheck
            ];
          };
        }
      );

    };
}
