library(dplyr)
library(polite)
library(xml2)
library(magrittr)
library(rvest)
library(httr)
library(ggplot2)
library(syuzhet)
library(stringr)
library(tm)
library(wordcloud)
# Spirit Airline Review

polite::use_manners(save_as = "polite_scrape.R")

airlineURLs <- c(
  'https://www.airlinequality.com/airline-reviews/spirit-airlines/?sortby=post_date%3ADesc&pagesize=100#google_vignette',
  'https://www.airlinequality.com/airline-reviews/spirit-airlines/page/2/?sortby=post_date%3ADesc&pagesize=100',
  'https://www.airlinequality.com/airline-reviews/spirit-airlines/page/3/?sortby=post_date%3ADesc&pagesize=100'
)

allReviewerHeadline <- character()
allUserRating <- character()
allUserReview <- character()

for (url in airlineURLs) {
  airlineSession <- bow(url, user_agent = "Educational")
  airlineData <- scrape(airlineSession) %>%
    html_elements('div.col-content')
  
  reviewerHeadline <- airlineData %>%
    html_nodes('h2.text_header') %>%
    html_text()
  
  userRating <- airlineData %>%
    html_nodes('div.rating-10') %>%
    html_text()
  
  userReview <- airlineData %>%
    html_nodes('div.text_content') %>%
    html_text()
  
  # Initialize vectors
  reviewerHeadline[is.na(reviewerHeadline)] <- "N/A"
  userRating[is.na(userRating)] <- "N/A"
  userReview[is.na(userReview)] <- "N/A"
  
  # Combine the data from the current URL with the overall data
  allReviewerHeadline <- c(allReviewerHeadline, reviewerHeadline)
  allUserRating <- c(allUserRating, userRating)
  allUserReview <- c(allUserReview, userReview)
}

cleanedAllUserReview <- gsub("^(✅ Trip Verified |Not Verified |)\\s*\\|\\s*", "", allUserReview)
cleanedAllUserReview <- gsub("c✅ Trip Verified \\| ", "",  cleanedAllUserReview)
cleanedAllUserReview <- gsub("✅ Trip Verified \\| ", "",  cleanedAllUserReview)

airline_df <- data.frame(
  Review = cleanedAllUserReview
)
cleanedAirlineDF <- distinct(airline_df)
View(cleanedAirlineDF)