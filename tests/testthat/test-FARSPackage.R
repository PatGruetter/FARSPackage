test_that("check number of rows", {
  expect_equal(nrow(fars_summarize_years(2014)), 12)
})
