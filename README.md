# budgetmanager

The goal of budgetmanager is to access your bank information (balance, operations, ...) directly through R.
In most cases, those informations can only be accessed through their website.
This package use Selenium and phantomjs (a headless web browser) to simulate a connexion to the bank website, gain the credentials and navigate through the pages to get whatever information is needed.

## Limitation

Currently, only Boursorama bank is working.

## Installation

You can install budgetmanager from github with:

``` r
# install.packages("devtools")
devtools::install_github("denrou/budgetmanager")
```

## Example

This is a basic example to get some informations about your bank account.

### Boursorama

``` r
# First, a Bank object needs to be created with your credentials
bank <- Bank$new("boursorama", my_account_number, my_password)

# This method will connect to the bank website
bank$connect_bank()

# Fetch the balance of your bank accounts
bank$get_balance()

# Download operations from all your bank accounts from january 2010 to today
bank$get_operations(from = as.Date("2010-01-01"), to = sys.Date(), by = "1 year")
```

### Crédit Agricole

``` r
# First, a Bank object needs to be created with your credentials
bank <- Bank$new("credit_agricole", my_account_number, my_password, postal_code)

# This method will connect to the bank website
bank$connect_bank()

# Fetch the balance of your bank accounts
bank$get_balance()
```
