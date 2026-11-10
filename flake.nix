{
  description = "Freestanding rusty env for frosty";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      };

      rustToolchain = pkgs.rust-bin.nightly.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
          "llvm-tools-preview"
        ];
        targets = [ "x86_64-unknown-none" ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain

          nasm
          cargo-bootimage
          xorriso
          mtools

          qemu
          gdb
          lld
          radare2
        ];
      };
    };
}
