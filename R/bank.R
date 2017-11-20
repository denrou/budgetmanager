#' Connection to Bank website
#'
#' Create a class which will connect to a given bank when initialized and
#' download useful information which we want to store (balance, operations).
#'
#' @section Usage:
#' \preformatted{
#'   bank <- Bank$new()
#'   bank$connect_driver(path_to_phantomjs = "")
#'   bank$connect_bank(bank, account_number, password)
#'   bank$get_balance()
#'   bank$get_operations(from = NULL, to = NULL)
#'   bank$disconnect_driver()
#' }
#'
#' @section Arguments:
#' \describe{
#'   \item{bank}{Character, which bank to connect to}
#'   \item{account_number}{Numeric or character}
#'   \item{password}{Numeric or character}
#'   \item{path_to_phantomjs}{Character}
#'   \item{from}{Date}
#'   \item{to}{Date}
#' }
#'
#' @section Details:
#' \code{$new()} creates a new instance of a bank object
#'
#' \code{$connect_driver()} opens a web driver
#'
#' \code{$connect_bank()} connects to a bank website
#'
#' \code{$get_balance()} retrieves the balance for each account
#'
#' \code{$get_operations()} retrieves operations from one date to another
#'
#' \code{$disconnect_driver()} disconnect the web driver
#'
#' @importFrom R6 R6Class
#'
#' @name Bank
#'
NULL


#' @importFrom RSelenium remoteDriver startServer
#' @importFrom wdman phantomjs
#'
#' @export
#'
Bank <- R6Class(
  "bank",
  public = list(
    bank = NULL,
    account_number = NULL,
    password = NULL,
    postal_code = NULL,
    initialize = function(bank, account_number, password, postal_code = NULL) {
      self$bank <- tolower(bank)
      self$account_number <- account_number
      self$password <- password
      self$postal_code <- postal_code
      self$connect_driver()
    },
    connect_driver = function(){
      private$phantomjs <- phantomjs(port = 4444L, verbose = FALSE, check = FALSE)
      private$remote_driver <- remoteDriver(browserName = "phantomjs", port = 4444L)
      private$remote_driver$open(silent = TRUE)
    },
    disonnect_driver = function() {
      private$remote_driver$close()
      private$phantomjs$stop()
    },
    connect_bank = function() {
      switch(self$bank,
             boursorama = connect_boursorama(private$remote_driver, self$account_number, self$password),
             credit_agricole = connect_credit_agricole(private$remote_driver, self$account_number, self$password, self$postal_code),
             stop("Only boursorama and credit_agricole are currently supported as bank."))
    },
    get_balance = function() {
      switch(self$bank,
             boursorama = get_balance_boursorama(private$remote_driver),
             credit_agricole = get_balance_credit_agricole(private$remote_driver),
             stop("Only boursorama and credit_agricole are currently supported as bank."))
    },
    get_operation = function(from = as.Date("2000-01-01"), to = Sys.Date(), by = "1 year") {
      switch(self$bank,
             boursorama = get_operations_boursorama(private$remote_driver, from, to, by),
             stop("Only boursorama is currently supported as bank."))
    }
  ),
  private = list(
    phantomjs = NULL,
    remote_driver = NULL
  )
)
