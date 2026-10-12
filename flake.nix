{
  description = "Termusic, a terminal music and podcast player written in Rust";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;

      mkTermusic = pkgs: pkgs.rustPlatform.buildRustPackage {
        pname = "termusic";
        version = "0.13.2";

        src = ./.;
        cargoLock.lockFile = ./Cargo.lock;
        cargoBuildFlags = [ "--workspace" ];
        cargoTestFlags = [ "--workspace" ];

        nativeBuildInputs = with pkgs; [
          clang
          pkg-config
          protobuf
        ];

        buildInputs = with pkgs; [
          alsa-lib
          dbus
        ];

        installPhase = ''
          for binary in termusic termusic-server; do
            binary_path=$(find target -type f -path "*/release/$binary" -print -quit)
            install -Dm755 "$binary_path" "$out/bin/$binary"
          done
        '';

        meta = with pkgs.lib; {
          homepage = "https://github.com/tramhao/termusic";
          description = "Terminal music and podcast player";
          license = with licenses; [ mit gpl3Only ];
          mainProgram = "termusic";
          platforms = platforms.linux;
        };
      };
    in {
      packages = forEachSystem (system: {
        default = mkTermusic nixpkgs.legacyPackages.${system};
        termusic = self.packages.${system}.default;
      });

      apps = forEachSystem (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/termusic";
          meta.description = "Run the Termusic terminal application";
        };
      });

      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              clippy
              rustc
              rustfmt
              clang
              pkg-config
              protobuf
              alsa-lib
              dbus
              ffmpeg
              yt-dlp
            ];
          };
        });
    };
}
