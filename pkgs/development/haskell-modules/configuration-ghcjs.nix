{ pkgs }:

with import ./lib.nix { inherit pkgs; };
let stdenv = pkgs.stdenv;
in
self: super: {

  mkDerivation = drv: super.mkDerivation (drv // { doHaddock = false; });

  # This is the list of packages that are built into a booted ghcjs installation
  # It can be generated with the command:
  # nix-shell '<nixpkgs>' -A pkgs.haskellPackages_ghcjs.ghc --command "ghcjs-pkg list | sed -n 's/^    \(.*\)-\([0-9.]*\)$/\1_\2/ p' | sed 's/\./_/g' | sed 's/-\(.\)/\U\1/' | sed 's/^\([^_]*\)\(.*\)$/\1 = null;/'"
  Cabal = null;
  aeson = null;
  array = null;
  async = null;
  attoparsec = null;
  base = null;
  binary = null;
  rts = null;
  bytestring = null;
  case-insensitive = null;
  containers = null;
  deepseq = null;
  directory = null;
  dlist = null;
  extensible-exceptions = null;
  filepath = null;
  ghc-prim = null;
  ghcjs-base = null;
  ghcjs-prim = null;
  hashable = null;
  integer-gmp = null;
  mtl = null;
  old-locale = null;
  old-time = null;
  parallel = null;
  pretty = null;
  primitive = null;
  process = null;
  scientific = null;
  stm = null;
  syb = null;
  template-haskell = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  unordered-containers = null;
  vector = null;

  transformers-compat = overrideCabal super.transformers-compat (drv: {
    configureFlags = [];
  });

  xml-types = dontHaddock super.xml-types;
  system-filepath = dontHaddock super.system-filepath;
  base16-bytestring = dontHaddock super.base16-bytestring;
  base64-bytestring = dontHaddock super.base64-bytestring;
  exceptions = dontHaddock super.exceptions;
  dependent-map = overrideCabal super.dependent-map (drv: {
    preConfigure = ''
      sed -i 's/^.*trust base.*$//' *.cabal
    '';
  });

  profunctors = overrideCabal super.profunctors (drv: {
    preConfigure = ''
      sed -i 's/^{-# ANN .* #-}//' src/Data/Profunctor/Unsafe.hs
    '';
  });

  "ghcjs-dom" = self.callPackage
    ({ mkDerivation, base, mtl, text, ghcjs-base
     }:
     mkDerivation {
       pname = "ghcjs-dom";
       version = "0.1.1.3";
       sha256 = "0pdxb2s7fflrh8sbqakv0qi13jkn3d0yc32xhg2944yfjg5fvlly";
       buildDepends = [ base mtl text ghcjs-base ];
       description = "DOM library that supports both GHCJS and WebKitGTK";
       license = stdenv.lib.licenses.mit;
       hydraPlatforms = stdenv.lib.platforms.none;
     }) {};
}
