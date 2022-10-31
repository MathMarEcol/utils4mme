
<!-- README.md is generated from README.Rmd. Please edit that file -->

# utils4mme <a href='https://github.com/MathMarEcol/utils4mme'><img src='man/figures/MME_Hex.png' align="right" height="150" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

utilsmme is collection of utilities developed by and for the
Mathematical Marine Ecology Lab (MME) at the University of Queensland.
They are intended for use within the lab to facilitate ease of
code-sharing and reducing the amount of repetitive code that must be
maintained. The authors of this package compiled the functions and
maintain the package, but the author of the individual functions are
indicated in the function help.

## Installation

Please note this is a private repository so you will need to verify your
identify with GitHub via a personal access token (PAT) prior to
installing. Best practice is to save your PAT in env var called
GITHUB_PAT or by using the `gitcreds` package that comes with
[`usethis`](https://usethis.r-lib.org/articles/git-credentials.html).
After storing your PAT, you can install the development version of
`utils4mme` like so:

``` r
devtools::install_github("https://github.com/MathMarEcol/utils4mme")
```

Alternatively, you can install by pasting your PAT directly into the
install line.

``` r
devtools::install_github("https://github.com/MathMarEcol/utils4mme", auth_token = "<INSERT_PAT_HERE>")
```

For further information see <https://happygitwithr.com/https-pat.html>
and <https://usethis.r-lib.org/articles/git-credentials.html>

## Example
