#' Get balance account
#'
#' Fetch from website the balance of every account registered
#'
#' @param driver a \code{\link[=RSelenium]{remoteDriver}} object
#'
#' @return a data frame
#'
#' @importFrom dplyr filter_ mutate_ mutate_at select_
#' @importFrom purrr map_df
#' @importFrom rvest html_nodes html_table
#' @importFrom stats setNames
#' @importFrom xml2 read_html
#'
get_balance_boursorama <- function(driver) {
  page_source <- driver$getPageSource()[[1]]
  page_source %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table() %>%
    map_df(mutate_, .dots = list(i = "1:n()")) %>%
    filter_("i > 1") %>%
    select_("-i") %>%
    setNames(c("Account", "Balance")) %>%
    mutate_at("Balance", get_number)
}

get_number <- function(x) {
  x <- gsub("[[:space:][:punct:]]", "", x)
  as.numeric(x) / 100
}
