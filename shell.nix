{ pkgs ? import <nixpkgs> {} }:
let
  pythonPackages = pkgs.python3Packages;
  buildDeps = [
    pkgs.libjpeg
    pkgs.graphicsmagick
    pkgs.ffmpeg
    pkgs.zlib
  ];
in
  pkgs.mkShell {
    nativeBuildInputs = buildDeps ++ (with pythonPackages; [
      babel
      jinja2
      path
      ruamel-yaml
      future
      pillow
      markdown
    ]);

    buildInputs = [
      (pythonPackages.buildPythonPackage {
        pname = "prosopopee";
        version = "1.0.0";
        src = ./.;
        propagatedBuildInputs = [
          pythonPackages.babel
          pythonPackages.jinja2
          pythonPackages.path
          pythonPackages.ruamel-yaml
          pythonPackages.future
          pythonPackages.pillow
        ];
        meta = with pkgs.lib; {
          description = "A static website generator that allows you to tell a story with your pictures";
          license = licenses.gpl3Plus;
        };
      })
    ];

    shellHook = ''
      echo "Entering Nix Shell with prosopopee dependencies..."
      echo "try running \`python -m prosopopee.prosopopee build\`"
    '';
  }