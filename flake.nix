{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    libvorbis_src.url = "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz";
    libvorbis_src.flake = false;

    libogg.url = "github:grumnix/libogg-win32";
    libogg.inputs.nixpkgs.follows = "nixpkgs";
    libogg.inputs.tinycmmc.follows = "tinycmmc";
  };

  outputs = { self, nixpkgs, tinycmmc, libvorbis_src, libogg }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = libvorbis;

          libvorbis = pkgs.stdenv.mkDerivation {
            pname = "libvorbis";
            version = "1.3.7";

            src = libvorbis_src;

            buildInputs = [
              libogg.packages.${pkgs.system}.default
            ];
          };
        };
      }
    );
}
