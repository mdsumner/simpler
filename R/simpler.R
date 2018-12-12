
assoc_triangle <- function(x) {
  sq <- seq_len(nrow(x))
  cbind(sq[-(length(sq) + -1:0)], sq[-c(1, 2)], sq[-c(1, length(sq))])
}

#' Simplify a path
#'
#' @param x
#'
#' @param keep_pc
#'
#' @name simplify_line
#' @export
#' @examples
#' set.seed(7)
#' x <- cbind(1:10, sort(rnorm(10)))
#' keep_pc <- 0.1
#' simplify_path(x, keep_pc = 0.1)
simplify_path <- function(x, keep_pc = 0.1) {
  len <- nrow(x)

  cnt <- 0
  tri <- assoc_triangle(x)
  bad <- rep(FALSE, len)
  a <- c(Inf, tri_area(x[t(tri), ]), Inf)

  residue <- 1 - keep_pc

  while(nrow(tri) > 5 &&(nrow(tri) + 2) > (len * keep_pc)) {
    cnt <- cnt + 1
    a <- c(Inf, tri_area(x[t(tri), ]), Inf)

    print(cnt)
    bb <- cbind(rbind(NA, tri, NA), a)
    amin <- which(a < quantile(a, residue/2))
    tri <- bb[c(-1, -amin, -nrow(bb)),1:3]
    a <- a[-amin]
    bad[amin] <- TRUE
  }
  x[!bad, ]
}
