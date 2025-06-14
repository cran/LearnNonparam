#' @title `r Sign$private_fields$.name`
#' 
#' @description Performs two-sample sign test on samples.
#' 
#' @aliases paired.sign
#' 
#' @examples
#' t <- pmt(
#'     "paired.sign",
#'     alternative = "greater", n_permu = 0
#' )$test(
#'     rep(c(+1, -1), c(12, 5)), rep(0, 17)
#' )$print()
#' 
#' t$type <- "asymp"
#' t
#' 
#' @export
#' 
#' @importFrom R6 R6Class
#' @importFrom stats pnorm


Sign <- R6Class(
    classname = "Sign",
    inherit = TwoSamplePairedTest,
    cloneable = FALSE,
    public = list(
        #' @description Create a new `Sign` object.
        #' 
        #' @template pmt_init_params
        #' 
        #' @return A `Sign` object.
        initialize = function(
            type = c("permu", "asymp"),
            alternative = c("two_sided", "less", "greater"),
            n_permu = 1e4, correct = TRUE
        ) {
            self$type <- type
            self$alternative <- alternative
            self$n_permu <- n_permu
            self$correct <- correct
        }
    ),
    private = list(
        .name = "Two-Sample Sign Test",

        .correct = NULL,

        .define = function() {
            private$.statistic_func <- function(...) function(x, y) sum(x > y)
        },

        .calculate_p = function() {
            n <- nrow(private$.data)

            z <- private$.statistic - n / 2
            correction <- if (private$.correct) {
                switch(private$.side, lr = sign(z) * 0.5, r = 0.5, l = -0.5)
            } else 0
            z <- (z - correction) / sqrt(n / 4)

            private$.p_value <- get_p_continous(z, "norm", private$.side)
        }
    ),
    active = list(
        #' @template active_params
        correct = function(value) {
            if (missing(value)) {
                private$.correct
            } else if (length(value) == 1 && is.logical(value)) {
                private$.correct <- as.logical(value)
                if (!is.null(private$.raw_data) && private$.type == "asymp") {
                    private$.calculate_p()
                }
            } else {
                stop("'correct' must be a single logical value")
            }
        }
    )
)