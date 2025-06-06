#' Get (Self) Preferences
#'
#' @param user `r template_var_user()`
#' @param pass `r template_var_pass()`
#' @param auth `r template_var_auth()`
#' @param clean `r template_var_clean()`
#'
#' @concept actor
#'
#' @return a [tibble::tibble] of preferences
#' @export
#'
#' @section Lexicon references:
#' [actor/getPreferences.json (2023-10-01)](https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getPreferences.json)
#'
#' @section Function introduced:
#' `v0.0.1` (2023-10-01)
#'
#' @examplesIf has_bluesky_pass() && has_bluesky_user()
#' bs_get_preferences()
bs_get_preferences <- function(user = get_bluesky_user(), pass = get_bluesky_pass(),
                               auth = bs_auth(user, pass), clean = TRUE) {
  req <- httr2::request('https://bsky.social/xrpc/app.bsky.actor.getPreferences') |>
    httr2::req_auth_bearer_token(token = auth$accessJwt)

  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (!clean) {
    return(resp)
  }

  resp <- resp |>
    purrr::pluck('preferences')

  tibble::tibble(
    `$type` = purrr::map_chr(resp, function(x) x[['$type']]),
    details = purrr::map(resp, function(x) widen(x[-1])),
  )
}
