install.packages("readr")
library(readr)
library(tidyverse) 
library(lubridate) 
library(ggplot2)

folder_path <- "Dataset"

zip_files <- list.files(folder_path, pattern = ".zip", full.names = TRUE)

for (zip_file in zip_files) {
  unzip(zip_file, exdir = folder_path)
  
  csv_file <- list.files(folder_path, pattern = ".csv", full.names = TRUE)
  
  data <- read_csv(csv_file)
  
  print(str(data))
}

colnames(data)
str(data)

# Clean Up and Add Date to Prepare for Analysis on Rides and Riders
data <- data %>% 
  select(-c(start_lat, start_lng, end_lat, end_lng))

colnames(data) 
nrow(data) 
dim(data) 
head(data) 
str(data) 
summary(data)

# How many observations fall under each rider type?
table(data$member_casual)

data$date <- as.Date(data$started_at) 
data$month <- format(as.Date(data$date), "%B")
data$day <- format(as.Date(data$date), "%d")
data$year <- format(as.Date(data$date), "%Y")
data$day_of_week <- format(as.Date(data$date), "%a")

data$ride_length <- difftime(data$ended_at, data$started_at, units = "mins")

str(data)

is.factor(data$ride_length)
data$ride_length <- as.numeric(as.character(data$ride_length))
is.numeric(data$ride_length)

# copy the dataframe
data_v2 <- data[!(data$ride_length > 1440 | data$ride_length <= 0),]
str(data_v2)

# create a new dataframe'
all_stations <- bind_rows(data.frame("stations" = data_v2$start_station_name, 
                                     "member_casual" = data_v2$member_casual),
                          data.frame("stations" = data_v2$end_station_name,
                                     "member_casual" = data_v2$member_casual))
all_stations_v2 <- all_stations[!(all_stations$stations == "" | is.na(all_stations$stations)),]
all_stations_member <- all_stations_v2[all_stations_v2$member_casual == 'member',]
all_stations_casual <- all_stations_v2[all_stations_v2$member_casual == 'casual',]

# 1 Stations, top 10 all, members, and casual riders
top_10_station <- all_stations_v2 %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  slice(1:10)

top_10_station_member <- all_stations_member %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  head(n=10)

top_10_station_casual <- all_stations_casual %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  head(n=10)


# Top 20 start stations for casual riders
data_v2 %>% 
  group_by(start_station_name, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(start_station_name != "", member_casual != "member") %>% 
  arrange(-number_of_rides) %>% 
  head(n=20)


# 2. Descriptive analysis on ride length
summary(data_v2$ride_length)
data_v2 %>% 
  summarise(min_ride_length = min(ride_length), 
            max_ride_length = max(ride_length),
            median_ride_length = median(ride_length),
            mean_ride_length = mean(ride_length))

# Compare ride length between members and casual riders
aggregate(data_v2$ride_length ~ data_v2$member_casual, FUN = mean)
aggregate(data_v2$ride_length ~ data_v2$member_casual, FUN = median)
aggregate(data_v2$ride_length ~ data_v2$member_casual, FUN = max)
aggregate(data_v2$ride_length ~ data_v2$member_casual, FUN = min)

# 3 By day
aggregate(data_v2$ride_length ~ data_v2$member_casual + data_v2$day_of_week, FUN = mean)

data_v2$day_of_week <- ordered(data_v2$day_of_week, 
                                    levels = c("Mon", 
                                               "Tue", "Wed",
                                               "Thu", "Fri", "Sat", "Sun"))

aggregate(data_v2$ride_length ~ data_v2$member_casual + data_v2$day_of_week, FUN = mean)

aggregate(data_v2$ride_length ~ data_v2$member_casual + data_v2$day_of_week, FUN = median)

data_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  arrange(day_of_week)

# 4. by month
data_v2$month <- ordered(data_v2$month, 
                              levels = c("January", "February", "March",
                                         "April", "May", "June",
                                         "July", "August", "September",
                                         "October", "November"))

aggregate(data_v2$ride_length ~ data_v2$member_casual + data_v2$month, FUN = mean)

aggregate(data_v2$ride_length ~ data_v2$member_casual + data_v2$month, FUN = median)

data_v2 %>% 
  group_by(member_casual, month) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  arrange(month)

# 5. By bike type
data_v2 %>% 
  group_by(rideable_type, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop')

data_v2 %>% 
  filter(rideable_type == 'docked_bike') %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  arrange(day_of_week)

data_v2 %>% 
  filter(rideable_type == 'docked_bike', member_casual == 'casual') %>% 
  group_by(day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop')

# Data Visualization
my_theme = theme(plot.title=element_text(size=20),
                 axis.text.x=element_text(size=16), 
                 axis.text.y=element_text(size=16),
                 axis.title.x=element_text(size=18), 
                 axis.title.y=element_text(size=18),
                 strip.text.x=element_text(size=16), 
                 strip.text.y=element_text(size=16),
                 legend.title=element_text(size=18), 
                 legend.text=element_text(size=16))

options(repr.plot.width = 6, repr.plot.height = 8)

# Viz 1 - general average riding duration between members and casual riders
data_v2 %>% 
  group_by(member_casual) %>% 
  summarize(average_duration = mean(ride_length)) %>% 
  ggplot(aes(x = member_casual, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = "Rider Type", y = "Average Duration (min)", 
       title = "Average Riding Duration by Rider Type") +
  theme_minimal()  

# Viz 2 - average riding duration of each day of week between members and casual riders
my_palette <- viridisLite::viridis(2)
data_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(average_duration = mean(ride_length), .groups = 'drop') %>% 
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = my_palette) +  
  labs(x = "Day of Week", y = "Average Duration (min)", 
       fill = "Member/Casual",
       title = "Average Riding Duration by Day: Members vs. Casual Riders") +
  theme_minimal() 

# Viz 3 - average number of rides of each day of week between members and casual riders
data_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  labs(x = "Day of Week", y = "Number of Rides", fill = "Member/Casual",
       title = "Average Number of Rides by Day: Members vs. Casual Riders") +
  theme_minimal()

# viz 4
options(repr.plot.width = 10, repr.plot.height = 8)
data_v2 %>% 
  group_by(month, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(member_casual == 'casual') %>%
  drop_na() %>%
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) + 
  geom_bar(position = 'dodge', stat = 'identity') + scale_y_continuous(labels = scales::comma) +
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8)) + 
  labs(x = "Month", y = "Number of Rides", 
       fill = "Member/Casual",
       title = "Average Number of Rides by Month: Casual Riders")

# viz 5 
str(data_v2)
data_v2$started_at_hour <- as.POSIXct(data_v2$started_at, "%Y-%m-%d %H:%M:%S")      
str(data_v2)

options(repr.plot.width = 12, repr.plot.height = 8)

data_v2 %>%
  filter(member_casual == 'casual') %>%
  group_by(hour_of_day = hour(round_date(started_at_hour, 'hour'))) %>% 
  group_by(hour_of_day, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  arrange(-number_of_rides) %>% 
  ggplot(aes(x = hour_of_day, y = number_of_rides, fill = member_casual)) +
  geom_bar(position = 'dodge', stat = 'identity') + 
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)) +
  labs(x = "Time of the Day (h)", y = "Number of Rides", 
       fill = "Member/Casual",
       title = "Average Number of Rides by Hour: Casual Riders") +
  theme_minimal()

# viz 6 top 10 stations
ggplot(data = top_10_station_member) +
  geom_col(aes(x = reorder(stations, station_count), y = station_count), fill = "thistle") +
  geom_text(aes(x = reorder(stations, station_count), y = station_count, label = station_count),
            vjust = -0.5, hjust = -0.2, color = "black", size = 3) +  # Menambah label
  labs(title = "Top 10 Used Stations by Members", y = "Number of Rides", x = "") +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  theme_minimal()

# viz 7 top 10 stations (casual )
ggplot(data = top_10_station_casual) +
  geom_col(aes(x = reorder(stations, station_count), y = station_count), fill = "lightsalmon") +
  geom_text(aes(x = reorder(stations, station_count), y = station_count, label = station_count),
            vjust = -0.5, hjust = 0, color = "black", size = 3) +  
  labs(title = "Top 10 Used Stations by Casual Riders", x = "", y = "Number of Rides") + 
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  theme_minimal()

# viz 8 top 10 start stations (casual riders)
data_v2 %>% 
  group_by(start_station_name, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(start_station_name != "", member_casual != "member") %>% 
  arrange(-number_of_rides) %>% 
  head(n=10) %>%
  ggplot(aes(x = reorder(start_station_name, number_of_rides), y = number_of_rides)) +
  geom_col(position = 'dodge', fill = '#f8766d') +
  geom_text(aes(label = number_of_rides), position = position_dodge(width = 0.9), vjust = 0) +  
  scale_y_continuous(labels = scales::comma) +
  labs(title = 'Top 10 Start Stations for Casual Riders', x = '', y = "Number of Rides") +
  coord_flip() +
  theme_minimal()

# viz 9
options(repr.plot.width = 12, repr.plot.height = 8)

data_v2 %>% 
  group_by(rideable_type, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_wrap(~rideable_type) +
  labs(fill = "Member/Casual", x = "", y = "Number of Rides", 
       title = "Usage of Different Bikes: Members vs. Casual Riders") +  theme_minimal()

# viz 10 
options(repr.plot.width = 14, repr.plot.height = 10)

data_v2 %>% 
  group_by(month, member_casual, rideable_type) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_grid(member_casual~rideable_type) +
  labs(x = "Month", y = "Number of Rides", fill = "Member/Casual",
       title = "Average Number of Rides by Month") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  

# viz 11
data_v2 %>% 
  group_by(month, day_of_week, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_grid(member_casual~month) +
  labs(x = "Day of Week", y = "Number of Rides", fill = "Member/Casual",
       title = "Bike Usage between Members and Casual Riders by Day of Week across the Year", fill = 'Member/Casual') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))