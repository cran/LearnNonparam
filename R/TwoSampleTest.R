#' @title TwoSampleTest Class
#' 
#' @description Abstract class for two-sample tests.
#' 
#' @aliases class.twosample
#' 
#' @importFrom R6 R6Class


TwoSampleTest <- R6Class(
    classname = "TwoSampleTest",
    inherit = PermuTest,
    cloneable = FALSE,
    private = list(
        .preprocess = function() {
            if (length(private$.raw_data) != 2) {
                stop("Must provide two samples")
            }

            private$.data <- `names<-`(private$.raw_data, c("x", "y"))
        },

        .calculate_score = function() {
            score <- get_score(
                c(private$.data$x, private$.data$y), scoring = private$.scoring
            )

            x_index <- seq_along(private$.data$x)
            private$.data$x <- score[x_index]
            private$.data$y <- score[-x_index]
        },

        .calculate_statistic = function() {
            private$.statistic <- twosample_pmt(
                private$.data$x,
                private$.data$y,
                private$.statistic_func,
                if (private$.type == "permu") private$.n_permu else NA_real_,
                isTRUE(getOption("LearnNonparam.pmt_progress"))
            )
        }
    )
)