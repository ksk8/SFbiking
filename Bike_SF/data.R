library (lubridate)
library(ggplot2)
library(ggrepel)
library(zoo)
library(dplyr)
library(data.table)
library(ggmap)
library(magrittr)
library(plotly) #3D plotting

trip <- fread("trip.csv")
station <- fread("station.csv")
status <- fread("status.csv")
weather <- fread("weather.csv")

#Make samples to view
#trip_sample <- sample_n(trip, 100, replace = FALSE)
#station_sample <- sample_n(station, 100, replace = TRUE)
#status_sample <- sample_n(status, 100, replace = FALSE)
#weather_sample <- sample_n(weather, 100, replace = FALSE)
#######

best_bike <- trip %>%
  count(bike) %>%
  arrange(desc(n))

ids <- trip %>%
  count(start_station_id) %>% filter(n < 2000) %>%
  arrange(desc(n))

trips = trip[trip$start_station_id %in% ids$start_station_id,]

#STATIONS IN SF
stations_SF <- station %>%
  filter(city == "San Francisco")

#TRIP SF
trip_SF <- trip %>%
  filter(start_station_id %in% stations_SF$id)

#TRIP PLOT
trip_plot <- trip_SF %>%
  group_by(start_station_id)%>%
  summarise(N = n())%>%
  filter(N > 30000)

plot <- ggplot(trip_plot, aes(as.character(start_station_id),N)) 
plot + geom_bar(stat = "identity", fill = "blue")

trip_SF <- mutate(trip_SF,duration_min = round(duration/60))

duration_plot <- ggplot(trip_SF, aes(duration_min))
duration_plot + geom_freqpoly() + xlim(c(0,30))

trip_SF <- trip_SF %>%
  filter(start_station_id != end_station_id & duration_min > 5)

trip_same_place_sample <- sample_n(trip_SF, 100, replace = FALSE)

duration_plot <- ggplot(trip_same_place, aes(duration_min))
duration_plot + geom_freqpoly() + xlim(c(0,300))

trip_NOT_same_place <- trip_SF %>%
  filter(start_station_id != end_station_id)

duration_plot <- ggplot(trip_NOT_same_place, aes(duration_min))
duration_plot + geom_freqpoly() + xlim(c(0,30))

trip_what_trip <- trip_SF %>%
  filter(duration_min > 5)%>%
  mutate(same = ifelse(start_station_id == end_station_id, "Same Station","Different Station"))%>%
  group_by(same)%>%
  summarise(N = n())

what_trip_plot <- ggplot(trip_what_trip, aes(same,N))
what_trip_plot + geom_bar(stat = "identity")

##### 
myLocation <- c(lon = -122.398, lat = 37.79)
myMap <- get_map(location=myLocation, source="google", maptype="roadmap", crop=FALSE, zoom = 15 )
map_stations <- ggmap(myMap)
map_stations + geom_point(data=stations_SF, aes(x=long, y=lat), color="black", size=1, alpha=1)

## FIND POPULAR ROUTES

## MAKE BOTH TRIP A -> B and B -> A count
trip_needed <- trip_SF %>%
  filter(start_station_id != end_station_id)%>%
  select(start_station_id,end_station_id)

trip_ <- trip_needed %>% plyr::rename(c('start_station_id'='id'))
trip_ <- trip_ %>% plyr::rename(c('end_station_id'='start_station_id'))
trip_ <- trip_ %>% plyr::rename(c('id'='end_station_id'))

trip_SF <- bind_rows(trip_needed,trip_)

trip_popular_routes <- trip_SF %>%
  group_by(start_station_id,end_station_id)%>%
  summarise(N = n())%>%
  arrange(desc(N))

station_coordinates <- stations_SF %>%
  select(id,lat,long)

trip_popular_routes <- trip_popular_routes %>% plyr::rename(c('start_station_id'='id'))
trip_popular_routes <- inner_join(trip_popular_routes,station_coordinates)
station_coordinates <- station_coordinates %>% plyr::rename(c('id'='end_station_id'))
trip_popular_routes <- inner_join(trip_popular_routes,station_coordinates, by = 'end_station_id')

ggmap(myMap) + 
  geom_segment(data = trip_popular_routes, aes(x=long.x, xend=long.y, y=lat.x, yend=lat.y,size=N, colour=N, alpha=N)) +
  theme_minimal()

trip_popular_routes <- trip_popular_routes %>% plyr::rename(c('id'='start_station_id'))

weather_events <- weather %>%
  count(events)








