#' Download operations from Boursorama
#'
#' Download operations from Boursorama bank on all account (except savings)
#'
#' @param driver a \code{\link[=RSelenium]{remoteDriver}} object
#' @param from,to a Date object
#' @param by increment of the sequence
#'
#' @return a data frame
#'
#' @importFrom dplyr mutate_at
#' @importFrom purrr map_df
#' @importFrom rvest html_session jump_to
#' @importFrom httr set_cookies
#' @importFrom lubridate as.duration
#' @importFrom glue glue
#' @importFrom readr cols col_date col_character col_number locale read_csv2
#' @importFrom stringr str_conv
#'
get_operations_boursorama <- function(driver, from = as.Date("2000-01-01"), to = Sys.Date(), by = "1 year") {
  cookie <- sapply(driver$getAllCookies(), function(c) {
    x <- c$value
    names(x) <- c$name
    x
  })
  url <- "https://clients.boursorama.com/"
  sess <- html_session(url, set_cookies(.cookies = cookie))
  from_date <- seq.Date(from = from, to = to, by = by)
  map_df(from_date, function(from_date) {
    file <- tempfile(fileext = ".csv")
    to_date <- as.Date(from_date + as.duration(by))
    url <- glue("https://clients.boursorama.com/budget/exporter-mouvements?movementSearch%5BfromDate%5D={from_date}&movementSearch%5BtoDate%5D={to_date}")
    csv <- jump_to(sess, url)
    writeBin(csv$response$content, file)
    col_types <- cols(
      dateOp = col_date("%d/%m/%Y"),
      dateVal = col_date("%d/%m/%Y"),
      label = col_character(),
      category = col_character(),
      categoryParent = col_character(),
      supplierFound = col_character(),
      amount = col_number(),
      accountNum = col_character(),
      accountLabel = col_character(),
      accountBalance = col_number()
    )
    locale <- locale(decimal_mark = ",", grouping_mark = " ")
    df <- read_csv2(file, col_types = col_types, locale = locale)
    unlink(file)
    df
  }) %>%
    mutate_at(c("category", "categoryParent"), str_conv, encoding = "ISO-8859-1")
}
