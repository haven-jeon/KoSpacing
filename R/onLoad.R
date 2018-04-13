

.KoSpacingEnv <- new.env()


.onLoad <- function(libname, pkgname) {
  Sys.setenv(TF_CPP_MIN_LOG_LEVEL=2)
}



#' @importFrom reticulate import import_builtins py_module_available use_condaenv conda_create conda_install conda_list
#' @import hashmap
.onAttach <- function(libname, pkgname){
  envnm <-'r-conda'

  tryCatch({
    if(!(envnm %in% conda_list()$name)){
      conda_create(envnm)
    }
  },
  error = function(e){
    stop("Need to install Anaconda3(>=3.6) from https://www.anaconda.com/download/.")
  },
  finally = {
    use_condaenv(envnm, required = TRUE)
    if(!py_module_available("tensorflow")){
      conda_install(envnm, packages=c('tensorflow=1.4.0'))
    }

    if(!py_module_available("keras")){
      conda_install(envnm, packages=c('keras=2.1.5'))
    }

    if(!py_module_available("h5py")){
      conda_install(envnm, packages=c('h5py'))
    }
  })

  w2idx <- file.path(system.file(package="KoSpacing"),"model", 'w2idx')

  w2idx_tbl <- load_hashmap(w2idx)

  assign("c2idx", w2idx_tbl, envir=.KoSpacingEnv)

  model_file <- file.path(system.file(package="KoSpacing"),"model", 'kospacing')
  model <- keras::load_model_hdf5(model_file)
  packageStartupMessage("loaded KoSpacing model!")
  assign("model", model, envir=.KoSpacingEnv)
}


