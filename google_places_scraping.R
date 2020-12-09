#USING THE GOOGLE PLACES API TO GATHER PHONE NUMBERS OF ESTABLISHMENTS AROUND KOLKATA
rm(list = ls())
username<-Sys.getenv("USERNAME")
#Creating an empty matrix that will get updated with phone numbers later 

phonenumbers = matrix(ncol=2)
colnames(phonenumbers) = c("mobile_local","mobile_international")

#Creating an empty matrix that will get updated with coordinates and place types the phone numbers are from
coordinates = matrix(ncol=3)
colnames(coordinates) = c("type", "lat", "lon")

library(googleway)

key <- '' #Put in a valid API key here

#List of available place types -- https://developers.google.com/places/supported_types

#Gathering a list of places for each place type 
types <- c("cafe", "car_dealer", "car_rental", "car_repair", "drugstore", "electrician", "hardware_store",
"home_goods_store", "laundry", "locksmith", "meal_delivery", "meal_takeaway", "moving_company", 
"painter", "plumber", "real_estate_agency", "roofing_contractor", "bakery", "pharmacy")


for (j in c(1:length(types))){
df_places <- google_places(search_string = types[j], radius = 25000, 
                           location = c(23.246785, 88.434311),   ## center of kolkata
                           key = key)

#Obtaining the PLACE IDs of all the places listed above
ids <- df_places$results$place_id
lat <- df_places$results$geometry$location$lat
lon <- df_places$results$geometry$location$lng

#Gathering phone numbers for each of the place ids above
for (i in c(1:length(ids))){
  details <- google_place_details(ids[i], key = key)
  place_latitude <- lat[i]
  place_lon <- lon[i]
  typ <-types[j]
  phonenumbers <- rbind(phonenumbers, c(details$result$formatted_phone_number, details$result$international_phone_number))
  coordinates <- rbind(coordinates, c(typ, place_latitude, place_lon))
}
}

write.table(phonenumbers,file = paste0('C:\\Users\\',username,'\\Dropbox\\phonenumbers.csv'),sep=",",row.names = FALSE)
write.table(coordinates,file = paste0('C:\\Users\\',username,'\\Dropbox\\coordinates.csv'),sep=",",row.names = FALSE)