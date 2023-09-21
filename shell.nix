with (import <nixpkgs> {});
let
  env = bundlerEnv {
    name = "Gaelan.github.io-bundler-env";
    inherit ruby;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };
in stdenv.mkDerivation {
  name = "Gaelan.github.io";
  buildInputs = [ env bundix ];
}
