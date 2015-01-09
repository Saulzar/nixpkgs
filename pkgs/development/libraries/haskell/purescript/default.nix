# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, fileEmbed, filepath, haskeline, monadUnify, mtl, nodejs
, optparseApplicative, parsec, patternArrows, time, transformers
, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "purescript";
  version = "0.6.3";
  sha256 = "0hd6aslsfw2jd06wyfzi1kr86vfj91ywvgl9rv9cyawzczk7l7v4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    fileEmbed filepath haskeline monadUnify mtl optparseApplicative
    parsec patternArrows time transformers unorderedContainers
    utf8String
  ];
  testDepends = [
    filepath mtl nodejs parsec transformers utf8String
  ];
  meta = {
    homepage = "http://www.purescript.org/";
    description = "PureScript Programming Language Compiler";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
