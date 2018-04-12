#' do korean spacing
#'
#' @param ko_sents korean sentences (limit of sentence length  is 198, must be splitted.)
#'
#' @return auto-spaced korean sentences
#'
#' @export
#' @import hashmap
spacing <- function(ko_sents){
  model <- get("model",envir=.KoSpacingEnv)
  spacing_ <- function(ko_sent){
    if(nchar(ko_sent) > 198){
      warning(sprintf("One sentence can not contain more than 198 characters. : %s", ko_sent))
    }
    ko_sent_ <- substr(ko_sent, 1, 198)
    mat <- sent_to_matrix(ko_sent_)
    results <- model$predict(mat)
    return(trimws(make_pred_sent(ko_sent_, results)))
  }
  ress <- sapply(ko_sents, spacing_, simplify = F, USE.NAMES = F)

  if(length(ress) == 1) ress <- ress[[1]]

  return(ress)
}



sent_to_matrix <- function(ko_sent){
  c2idx <- get("c2idx",envir=.KoSpacingEnv)
  ko_sent_ <- paste0("«",ko_sent, "»")
  ko_sent_ <- gsub('\\s', '^', ko_sent_)

  #encoding and padding
  encoded <- sapply(strsplit(ko_sent_, split='')[[1]], function(x){
    x_ <- enc2utf8(x)
    if(c2idx$has_key(x_)){
      ret <- c2idx[[x_]]
    }else{
      ret <- c2idx[['__ETC__']]
    }
    ret
    })

  mat <- matrix(data = c2idx[['__PAD__']], nrow = 1, ncol = 200)
  mat[,1:length(encoded)] <-  encoded
  return(mat)
}





make_pred_sent <- function(raw_sent, spacing_mat){
  raw_sent <- paste0('«', raw_sent, '»')
  spacing_prob <- spacing_mat[1:nchar(raw_sent)]
  raw_chars <- strsplit(raw_sent, split='')[[1]]

  ret_v <- c()
  for(i in 1:length(raw_chars)){
    if(spacing_prob[i] > 0.5){
      ret_v <- c(ret_v, raw_chars[i], " ")
    }else{
      ret_v <- c(ret_v, raw_chars[i])
    }
  }
  ret <- paste0(ret_v, collapse = '')
  ret <- gsub('[«|»]', '', ret)
  ret <- paste(strsplit(ret, split="[[:space:]]+")[[1]], collapse = ' ')
  return(ret)
}







