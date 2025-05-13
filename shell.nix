{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs)
    stdenv
    writeScript
    mkShell
  ;

  shellWrapper = writeScript "shell-wrapper" ''
    #! ${stdenv.shell}
    exec -a shell ${pkgs.fish}/bin/fish --login --interactive "$@"
  '';
in mkShell {
  name = "mc-shell";
  buildInputs = with pkgs; [
    glibcLocales
    git bashInteractive
    gnumake
    git
    automake
    autoconf
    libtool
    bear

    pkg-config
    glib
    gpm
    file
    e2fsprogs
    perl
    zip
    unzip
    gettext
    slang
    libssh2
    openssl
    coreutils
    xorg.libICE
    xorg.libX11
  ];
  shellHook = ''
    export LANG="en_US.UTF-8"
    export SHELL="${shellWrapper}"
    export TMP=/tmp
    export TMPDIR=$TMP

    if [ ! -z "$PS1" ]
    then
      exec "$SHELL"
    fi
  '';
}
