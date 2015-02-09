{ pkgs }:

with import ./lib.nix { inherit pkgs; };

let haddockSrc = pkgs.fetchgit {
      url = git://github.com/haskell/haddock.git;
      rev = "89fc5605c865d0e0ce5ed7e396102e678426533b";
      sha256 = "c89aba9760af93ebc8e083921c78ceae1069612bba1b0859f8b974178005f5c0";
    };
in

self: super: {

  # Disable GHC 7.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # We have Cabal 1.22.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # GHC 7.10.x's Haddock binary cannot generate hoogle files.
  # https://ghc.haskell.org/trac/ghc/ticket/9921
  mkDerivation = drv: super.mkDerivation (drv // { doHoogle = false; });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;

  # These used to be core packages in GHC 7.8.x.
  old-locale = self.old-locale_1_0_0_7;
  old-time = self.old-time_1_1_0_3;

  # We have transformers 4.x
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # We have time 1.5
  aeson = disableCabalFlag super.aeson "old-locale";

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    patchPhase = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    patchPhase = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });

  # bos/attoparsec#92
  attoparsec = dontCheck super.attoparsec;

  # test suite hangs silently for at least 10 minutes
  ChasingBottoms = dontCheck super.ChasingBottoms;
  split = dontCheck super.split;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Test suite hangs silently without consuming any CPU.
  # https://github.com/ndmitchell/extra/issues/4
  extra = dontCheck super.extra;

  # Test suite fails in "/tokens_bytestring_unicode.g.bin".
  alex = dontCheck super.alex;

  # encoding fails to build on GHC 7.10 because of the Applicative-Monad Proposal
  encoding = overrideCabal super.encoding (drv: {
    sha256 = null;
    src = pkgs.fetchdarcs {
      url = http://static.ryantrinkle.com/encoding;
      rev = "0.7.0.3";
      sha256 = "1ssg9galkpbig05q5vqhqzljk29dg9z9hs02aqjs2ljqqxx1xnjf";
    };
    version = "0.7.0.3";
  });

  bzlib = overrideCabal super.bzlib (drv: {
    sha256 = null;
    src = pkgs.fetchdarcs {
      url = http://static.ryantrinkle.com/bzlib;
      rev = "0.5.0.5";
      sha256 = "1s5igawbak3971zx9hh7msw08wsk97zs3a7b31ryjfrbrb0959wh";
    };
    editedCabalFile = null;
    version = "0.5.0.5";
  });

  haddock-library = overrideCabal super.haddock-library (drv: {
    sha256 = null;
    src = "${haddockSrc}/haddock-library";
    version = "1.2.0";
    doCheck = false;
    jailbreak = true;
  });

  haddock-api = overrideCabal super.haddock-api (drv: {
    sha256 = null;
    src = "${haddockSrc}/haddock-api";
    version = "2.16.0";
    doCheck = false;
    jailbreak = true;
  });

  haddock = overrideCabal super.haddock (drv: {
    sha256 = null;
    src = haddockSrc;
    version = "2.16.0";
    doCheck = false;
    jailbreak = true;
  });

  stringsearch = overrideCabal super.stringsearch (drv: {
    sha256 = null;
    src = pkgs.fetchhg {
      url = https://bitbucket.org/ryantrinkle/stringsearch;
      rev = "9709b7d1b244";
      sha256 = "12xcmyh4rzi7wnfflq8br3xl37aphdb61q7wj1cpzvi1zyngff64";
    };
    version = "0.3.6.6";
  });

  th-expand-syns = overrideCabal super.th-expand-syns (drv: {
    sha256 = null;
    src = pkgs.fetchgit {
      url = git://github.com/DanielSchuessler/th-expand-syns;
      rev = "25bf93ee8545f34ddd51192b230bbbc94d47039d";
      sha256 = "8aed02abfa77930f98a2ae9f3b55d905e4db6df5c7774e981289ce70e9ee83a7";
    };
    version = "0.4.0.2";
    jailbreak = true;
  });

  # intervals fails to build on GHC 7.10 due to 'null' being added to Foldable
  intervals = overrideCabal super.intervals (drv: {
    sha256 = null;
    src = pkgs.fetchgit {
      url = git://github.com/pacak/intervals;
      rev = "9f0eb8d0278745e0a46580d379dab57de8c9d7a0";
      sha256 = "3da3c33ef57afc488f03c8b8a52925c8c6bf4cf8aac854da48dd565c7b61384d";
    };
    version = "0.7.0.2";
  });

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ryantrinkle/ghcjs-prim.git;
      rev = "1d622ffecace0f56a73b7d32b71865d83fa2d496";
      sha256 = "609feced378a33dd62158b693876528da5293b86c38be7759002e4e09024cbdd";
    };
    buildDepends = [ primitive ];
    license = stdenv.lib.licenses.bsd3;
  }) {};

  heist = overrideCabal super.heist (drv: {
    sha256 = null;
    src = ../../../../heist;
    editedCabalFile = null;
    version = "0.14.0.2";
  });

  base64-bytestring = dontCheck super.base64-bytestring; # Hangs
  vector-algorithms = dontCheck super.vector-algorithms; # Hangs
  snap = overrideCabal super.snap (drv: {
    jailbreak = true;
    preConfigure = ''
      sed -i 's/template-haskell.*,/template-haskell -any,/' snap.cabal
    '';
  });
  haskell-src-meta = overrideCabal super.haskell-src-meta (drv: {
    sha256 = null;
    src = ../../../../haskell-src-meta;
    version = "0.6.0.8";
    jailbreak = true;
  });

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;
  cartel = overrideCabal super.cartel (drv: { doCheck = false; patchPhase = "sed -i -e 's|base >= .*|base|' cartel.cabal"; });

}
