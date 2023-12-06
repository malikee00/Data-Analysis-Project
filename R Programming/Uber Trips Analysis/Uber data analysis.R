install.packages("datatable")
library(DT)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(lubridate)
library(tidyr)
library(tidyverse) 
library(RColorBrewer)
library(scales)

apr <- read.csv("uber-raw-data-apr14.csv")
may <- read.csv("uber-raw-data-may14.csv")
june <- read.csv("uber-raw-data-jun14.csv")
july <- read.csv("uber-raw-data-jul14.csv")
aug <- read.csv("uber-raw-data-aug14.csv")
sept <- read.csv("uber-raw-data-sep14.csv")

data <- rbind(apr, may, june, july, aug, sept)
cat("The dim data are: ", dim(data))

head(data)

data$Date.Time <- as.POSIXct(data$Date.Time, format="%m/%d/%Y %H:%M:%S")
data$Time <- format(as.POSIXct(data$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format = "%H:%M:%S")
data$Date.Time <- ymd_hms(data$Date.Time)

data$day <- factor(day(data$Date.Time))
data$month <- factor(month(data$Date.Time, label=TRUE))
data$year <- factor(year(data$Date.Time))
data$dayofweek <- factor(wday(data$Date.Time, label=TRUE))

data$second = factor(second(hms(data$Time)))
data$minute = factor(minute(hms(data$Time)))
data$hour = factor(hour(hms(data$Time)))

head(data)

hourly_data <- data %>% 
  group_by(hour) %>% 
  dplyr::summarize(Total = n())

datatable(hourly_data)

hourly_data$hour <- factor(hourly_data$hour, levels = hourly_data$hour[order(hourly_data$Total, decreasing = TRUE)])

ggplot(hourly_data, aes(x = reorder(hour, Total), y = Total, fill = Total)) +
  geom_bar(stat = "identity", color = "white") +
  labs(title = "Trips Every Hour",
       subtitle = "Aggregated Today",
       x = "Hour of the Day",
       y = "Total Trips") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 12),
        axis.text.x = element_text(angle = 0, hjust = 1),
        axis.title = element_text(size = 14),
        legend.position = "none") +
  scale_fill_gradient(low = "yellow", high = "red", guide = "legend") +
  scale_y_continuous(labels = comma) +
  geom_text(aes(label = comma(Total), y = Total), vjust = 0, size = 3, color = "black") +
  coord_flip()  # To make the bars horizontal

month_hour_data <- data %>% group_by(month, hour) %>% dplyr::summarize(Total = n())

ggplot(month_hour_data, aes(hour, Total, fill=month)) + 
  geom_bar(stat = "identity") + 
  ggtitle("Trips by Hour and Month") + 
  scale_y_continuous(labels = comma)

day_data <- data %>% group_by(day) %>% dplyr::summarize(Trips = n())
day_data

ggplot(day_data, aes(day, Trips, fill = day)) + 
  geom_bar(stat = "identity") +
  ggtitle("Trips by Day of the Month") + 
  scale_fill_manual(values = viridis_pal()(length(unique(day_data$day))))+
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.text.x = element_text(angle = 0, hjust = 0.5),
        axis.title = element_text(size = 14),
        legend.position = "none") +
  scale_y_continuous(labels = scales::comma)

day_month_data <- data %>% group_by(dayofweek, month) %>% dplyr::summarize(Trips = n())
day_month_data

colors <- brewer.pal(6, "Set1")

ggplot(day_month_data, aes(dayofweek, Trips, fill = month)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  ggtitle("Trips by Day and Month") + 
  scale_y_continuous(labels = scales::comma) + 
  scale_fill_manual(values = colors, guide = "legend") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.text.x = element_text(angle = 0, hjust = 0.5),
        axis.title = element_text(size = 14),
        legend.position = "right") +
  geom_text(aes(label = scales::comma(Trips), group = month),
            position = position_dodge(width = 1),
            vjust = -0.5, size = 2, color = "black")

month_data <- data %>% group_by(month) %>% dplyr::summarize(Total = n())

month_data

colors <- brewer.pal(6, "Set1")

ggplot(month_data, aes(month, Total, fill = month)) + 
  geom_bar(stat = "identity", color = "white", size = 0.7) + 
  ggtitle("Trips in a Month") + 
  labs(x = "Month", y = "Total Trips") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.text.x = element_text(angle = 0, hjust = 0.5),
        axis.title = element_text(size = 14),
        legend.position = "none") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = colors) +
  geom_text(aes(label = comma(Total)), vjust = -0.5, size = 4, color = "black") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(colour = "black"))

day_hour_data <- data %>% group_by(day, hour) %>% dplyr::summarize(Total = n())
datatable(day_hour_data)

custom_colors <- c("blue", "lightblue", "white", "lightcoral", "red")

ggplot(day_hour_data, aes(day, hour, fill = Total)) + 
  geom_tile(color = "white") + 
  ggtitle("Heat Map by Hour and Day") +
  scale_fill_gradientn(colors = custom_colors) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.text.x = element_text(angle = 0, hjust = 0.5),
        axis.title = element_text(size = 14))

month_day_data <- data %>% group_by(month, day) %>% dplyr::summarize(Trips = n())
month_day_data

ggplot(month_day_data, aes(day, month, fill = Trips)) + 
  geom_tile(color = "white") + 
  ggtitle("Heat Map by Month and Day") +
  scale_fill_gradient(low = "skyblue", high = "blue") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(size = 14))

ggplot(day_month_data, aes(dayofweek, month, fill = Trips)) + 
  geom_tile(color = "white") + 
  ggtitle("Heat Map by Month and Day")