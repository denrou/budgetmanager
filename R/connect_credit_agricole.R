#' @title connect_boursorama
#'
#' @description
#' connect to the boursorama bank webpage
#'
#' @param driver a \code{\link[=RSelenium]{remoteDriver}} object
#'
#' @param account_number
#' a string corresponding to the cient account number
#'
#' @param password
#' a string corresponding to the password which connect to the account
#'
#' @param postal_code
#' an integer corresponding to the postal code of the bank (credit Agricole is a regionnal bank)
#'
#' @return
#' The webpage get after the submit request
#'
#' @importFrom rvest html_session html_form set_values submit_form
#' @importFrom glue glue
#'
connect_credit_agricole <- function(driver, account_number, password, postal_code) {
  # First, let's find the regionnal bank website based on postal code
  session <- html_session("https://www.credit-agricole.fr/")
  form <- html_form(session)[[2]]
  form <- set_values(form, cpfull = postal_code)
  new_url <- submit_form(session, form)

  # Now, let's go to the authentification page
  driver$setImplicitWaitTimeout(1000)
  driver$navigate(new_url$url)
  webelem <- driver$findElements("tag name", "a")[[10]]
  webelem$clickElement()
  webelem <- driver$findElements("name", "CCPTE")[[1]]
  webelem$clickElement()

  # Let's authenticate
  webelem$sendKeysToActiveElement(list(account_number))
  for (elem in strsplit(as.character(password), "")[[1]]) {
    driver$findElements("link text", glue("\n  {elem}  \n"))[[1]]$clickElement()
  }
  driver$findElements("link text", "Confirmer")[[1]]$clickElement()
}
