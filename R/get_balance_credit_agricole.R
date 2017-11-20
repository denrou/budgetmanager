#' Get balance account
#'
#' Fetch from website the balance of every account registered
#'
#' @param driver a \code{\link[=RSelenium]{remoteDriver}} object
#'
#' @return a data frame
#'
#' @importFrom dplyr slice n select mutate_at
#' @importFrom readr parse_number locale
#' @importFrom rvest html_nodes html_table
#' @importFrom magrittr set_colnames
#' @importFrom xml2 read_html
#'
get_balance_credit_agricole <- function(driver) {
  driver$findElements("link text", "Mes Comptes")[[1]]$clickElement()
  page_source <- driver$getPageSource()[[1]]
  table <- page_source %>% read_html() %>% html_nodes(".ca-table") %>% html_table(fill = TRUE)
  table <- table[[1]]
  table %>%
    slice(6:n()) %>%
    select(1, 3, 6) %>%
    set_colnames(c("account_type", "account_number", "amount")) %>%
    mutate_at("amount", parse_number, locale = locale(decimal_mark = ",", grouping_mark = " "))
}
