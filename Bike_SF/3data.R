
library(lubridate)
library(ggplot2)
library(ggrepel)
library(zoo)
library(dplyr)
library(data.table)
library(ggmap)
library(magrittr)

trip <- fread("trip.csv")
station <- fread("station.csv")
status <- fread("status.csv")
weather <- fread("weather.csv")

status_sample <- sample_n(status, 100, replace = FALSE)
