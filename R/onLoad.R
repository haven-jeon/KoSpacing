.KoSpacingEnv <- new.env()


.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL = 2)
}


#' @importFrom reticulate import import_builtins py_module_available
#' @importFrom keras load_model_hdf5
#' @import hashmap
.onAttach <- function(libname, pkgname) {
  w2idx <-
    file.path(system.file(package = "KoSpacing"), "model", 'w2idx_tbl.hm')

  w2idx_tbl <- load_hashmap(w2idx)

  assign("c2idx", w2idx_tbl, envir = .KoSpacingEnv)

  if (!py_module_available("tensorflow") ||
      !py_module_available("keras")) {
    packageStartupMessage(
      "This R Ssystem may not contain `tensorflow` or `keras`.
      Please install tensorflow first with command like `tensorflow::install_tensorflow()` and keras with
      `keras::install_keras()`"
    )
    return()
  }
  model_file <-
    file.path(system.file(package = "KoSpacing"), "model", 'kospacing')
  model <- load_model_hdf5(model_file)
  packageStartupMessage("loaded KoSpacing model!")
  assign("model", model, envir = .KoSpacingEnv)
}
