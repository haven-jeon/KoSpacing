#' @importFrom reticulate import import_builtins py_module_available use_condaenv conda_create conda_install conda_list
#' @export
set_env <- function() {
  envnm <- 'r-kospacing'
  reticulate::use_condaenv(envnm, required = TRUE)
  if (!reticulate::py_module_available("tensorflow")) {
    reticulate::conda_install(envnm, packages = c('tensorflow==1.9.0'))
  }

  if (!reticulate::py_module_available("keras")) {
    reticulate::conda_install(envnm, packages = c('keras==2.1.5'))
  }

  if (!reticulate::py_module_available("h5py")) {
    reticulate::conda_install(envnm, packages = c('h5py==2.7.1'))
  }
  cat("\nInstallation complete.\n\n")

  if (rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

  invisible(NULL)
}

check_env <- function() {
  reticulate::py_module_available("h5py")&
  reticulate::py_module_available("keras")&
  reticulate::py_module_available("tensorflow")
}

check_model <- function() {
  chk <- try(get("model", envir = .KoSpacingEnv), silent = T)
  if (class(chk)[1] == "try-error") {
    res <- F
  } else {
    res <- T
  }
  return(res)
}

#' @importFrom keras load_model_hdf5
#' @importFrom hashmap load_hashmap
#' @export
set_model <- function(){
  w2idx <-
    file.path(system.file(package = "KoSpacing"), "model", 'w2idx')

  w2idx_tbl <- hashmap::load_hashmap(w2idx)

  assign("c2idx", w2idx_tbl, envir = .KoSpacingEnv)

  model_file <-
    file.path(system.file(package = "KoSpacing"), "model", 'kospacing')

  model <- keras::load_model_hdf5(model_file)
  packageStartupMessage("loaded KoSpacing model!")
  assign("model", model, envir = .KoSpacingEnv)
}


check_conda_set <- function() {
  envnm <- 'r-kospacing'
  chk <- try(reticulate::use_condaenv(envnm, required = TRUE), silent = T)
  if (class(chk) == "try-error") {
    res <- F
  } else {
    res <- T
  }
  return(res)
}

#' Create Conda Env named r-kospacing
#'
#' @importFrom reticulate conda_create
#' @export
create_conda_env <- function(){
  reticulate::conda_create("r-kospacing", packages = "python=3.6")
  set_env()
}
