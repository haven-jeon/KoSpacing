

.KoSpacingEnv <- new.env()


.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL=2)
}



#' @importFrom reticulate import import_builtins py_module_available  virtualenv_install virtualenv_list use_virtualenv
#' @importFrom keras load_model_hdf5 install_keras
#' @import hashmap
.onAttach <- function(libname, pkgname){
  envnm <-'r-venv'

  tryCatch({
    vlist <- virtualenv_list()
    if(!(envnm %in% vlist)){
      packageStartupMessage('installing python envirement!')
      virtualenv_install(envnm, packages=c('tensorflow', 'keras', 'h5py'))
    }
  },
  error = function(e){
    packageStartupMessage('installing python envirement!')
    virtualenv_install(envnm, packages=c('tensorflow', 'keras', 'h5py'))
  },
  finally = {
    use_virtualenv(envnm)
  })

  w2idx <- file.path(system.file(package="KoSpacing"),"model", 'w2idx_tbl.hm')

  w2idx_tbl <- load_hashmap(w2idx)

  assign("c2idx", w2idx_tbl, envir=.KoSpacingEnv)

  if(!py_module_available("tensorflow") || !py_module_available("keras")){
    packageStartupMessage("This R System may not contain `tensorflow` or `keras`.
      Starting to install tensorflow and keras with `keras`")
    install_keras(extra_packages='h5py')
  }
  model_file <- file.path(system.file(package="KoSpacing"),"model", 'kospacing')
  model <- load_model_hdf5(model_file)
  packageStartupMessage("loaded KoSpacing model!")
  assign("model", model, envir=.KoSpacingEnv)
}


