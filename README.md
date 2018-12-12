
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpler

The goal of simpler is to provide the [Visvalingam
algorithm](https://bost.ocks.org/mike/simplify/) to simplifying paths.

Very much WIP\!

TODO:

  - distinguish shared boundaries from isolate lines, and drop short one
  - provide methods for various formats, especially polygons to shared
    boundaries
  - avoid recalculating every triangle area every iteration
  - methods to recompose shared paths as polygons

## Installation

Only from github

## Example

The USA example, from Natural Earth, the slowness here is a good
motivation to speed up the point cull.

``` r
library(simpler)
w <- rnaturalearth::ne_countries(scale = 10, country = "United States of America", returnclass = "sf")
x <- w$geometry[[1]][[1]][[1]]


op <- par(mfrow = c(3, 3), mar = rep(0, 4))
plot(x, type = "l", axes = FALSE)
for (kpc in c(0.4, rep(0.9, 7))) {
  x <- simplify_path(x, keep_pc = 0.3)
  plot(x, type = "l", axes = FALSE)
}
```

<img src="man/figures/README-usa-1.png" width="100%" />

``` r

par(op)
```

Simplify a bunch of shared lines between polygons.

``` r

library(silicate)
#> 
#> Attaching package: 'silicate'
#> The following object is masked from 'package:stats':
#> 
#>     filter
x <- ARC(inlandwaters)

get_pts <- function(x, i) {
  x$arc_link_vertex %>% dplyr::filter(arc_ == x$object_link_arc$arc_[i]) %>% 
    dplyr::inner_join(x$vertex, "vertex_") %>% dplyr::select(x_, y_) %>% as.matrix()
}
plot(x)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
sfx <- vector("list", nrow(x$object_link_arc))
plot(x$vertex$x_, x$vertex$y_, pch = ".", asp = 1, xlim = c(4e5, 2e6), ylim = c(-1e6, 0))
for (i in seq_along(x$object_link_arc$arc_)) {
 pts <- get_pts(x, i)
 path <- simplify_path(pts, keep_pc = 0.01)
 lines(path, col = rainbow(10)[i %% 10 + 1], lwd = 3)
 sfx[[i]] <- sf::st_linestring(path)
}
```

<img src="man/figures/README-example-2.png" width="100%" />

``` r

## this is a cheat because the polygons have to store any shared boundaries twice, 
pryr::object_size(sf::st_sfc(sfx))
#> 115 kB
pryr::object_size(inlandwaters)
#> 586 kB


plot(sf::st_sfc(sfx))
```

<img src="man/figures/README-example-3.png" width="100%" />
