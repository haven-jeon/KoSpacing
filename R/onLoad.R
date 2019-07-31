.KoSpacingEnv <- new.env()


.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL = 2)
}

.onAttach <- function(libname, pkgname){
  packageStartupMessage("If you install package first fime, ")
  packageStartupMessage("Please set_env() run before using spacing()")
}
