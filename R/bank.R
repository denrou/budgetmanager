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


#' @importFrom RSelenium phantom remoteDriver startServer
#'
#' @export
#'
Bank <- R6Class(
  "bank",
  public = list(
    initialize = function() {},
    connect_driver = function(path_to_phantomjs = ""){
      private$phantomjs <- phantom(pjs_cmd = path_to_phantomjs)
      Sys.sleep(1)
      private$remote_driver <- remoteDriver(browserName = 'phantomjs')
      private$remote_driver$open(silent = TRUE)
    },
    disonnect_driver = function() {
      private$remote_driver$close()
      private$phantomjs$stop()
    },
    connect_bank = function(bank, account_number, password) {
      switch(tolower(bank),
             boursorama = connect_boursorama(private, account_number, password),
             stop("Only boursorama is currently supported as bank."))
    },
    get_balance = function(bank) {
      switch(tolower(bank),
             boursorama = get_balance_boursorama(private$remote_driver),
             stop("Only boursorama is currently supported as bank."))
    }
  ),
  private = list(
    phantomjs = NULL,
    remote_driver = NULL
  )
)
