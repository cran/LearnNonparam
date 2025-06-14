#' @title `r KolmogorovSmirnov$private_fields$.name`
#' 
#' @description Performs two-sample Kolmogorov-Smirnov test on samples.
#' 
#' @aliases twosample.ks
#' 
#' @examples
#' pmt(
#'     "twosample.ks", n_permu = 0
#' )$test(Table2.8.1)$print()
#' 
#' @export
#' 
#' @importFrom R6 R6Class


KolmogorovSmirnov <- R6Class(
    classname = "KolmogorovSmirnov",
    inherit = TwoSampleTest,
    cloneable = FALSE,
    public = list(
        #' @description Create a new `KolmogorovSmirnov` object.
        #' 
        #' @template pmt_init_params
        #' 
        #' @return A `KolmogorovSmirnov` object.
        initialize = function(
            n_permu = 1e4
        ) {
            self$n_permu <- n_permu
        }
    ),
    private = list(
        .name = "Two-Sample Kolmogorov-Smirnov Test",

        .define = function() {
            private$.statistic_func <- function(x, y) {
                m <- length(x)
                n <- length(y)

                geq_m <- -1 / n
                leq_m <- rep.int(1 / m, m + n)

                function(x, y) {
                    max(abs(cumsum(`[<-`(leq_m, order(c(x, y)) > m, geq_m))))
                }
            }
        },

        .calculate_side = function() {
            private$.side <- "r"
        }
    )
)