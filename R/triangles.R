#' @name tri_area
tri_ix <- function(x) {
  offset <- rep(seq(0, nrow(x) - 1, by = 3), each = 3)
  c(3L, 1L, 2L) + offset
}
#' @name tri_area
tri_jx <- function(x) {
  offset <- rep(seq(0, nrow(x) - 1, by = 3), each = 3)
  c(1L, 2L, 3L) + offset
}

#' Area of triangles
#'
#' Input is x,y matrix in triplets
#'
#' `tri_ix` builds the i-index
#' `tri_jx` builds the j-index
#' @param x
#'
#' @return area of triangles (a vector of length nrow(x)/3)
#' @export
#' @examples
#' set.seed(7)
#' lin <- cbind(1:10, sort(rnorm(10)))
#' tri <- assoc_triangle(lin)
#' a <- tri_area(lin[t(tri), ])
#' plot(lin)
#' scl <- function(x) (x - min(x))/diff(range(x))
#' col <- grey(seq(0.2, 0.8, length = 20), alpha = 0.8)[scl(a) * (19) + 1]
#' ## smaller triangles are darker, get removed first
#' for (i in seq_len(nrow(tri))) polypath(lin[tri[i, ], ], col = col[i])
tri_area <- function(x) {
  ix <- tri_ix(x)
  jx <- tri_jx(x)
  abs(colSums(matrix((x[ix, 1] + x[jx, 1]) * (x[ix, 2] - x[jx, 2]), nrow = 3L))/2)
}
