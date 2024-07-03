# Open and look at a simulation output file
library(tidyverse)
library(tidync)
library(ncdf4)
library(here)
library(viridis)

plot_theme <- theme_minimal()+theme(panel.border = element_rect(color="black",fill=NA))
theme_black <- theme_minimal()+theme(panel.border = element_rect(color="black",fill=NA),text=element_text(color='white'))
theme_set(plot_theme)


ncfn <- here('data','coast_whale_toy_simulation','coast001_3d_sh00','release_2023.06.01.nc')

nc_open(ncfn)

nc <- tidync(ncfn)
nc


# 121,000 values, indexed by time and particle number
# variables:lon, lat, fractional z (cs), ocean time, z, salinity, temperature, surface z (zeta), bottom depth (h), u, v, w

# to pull all the data...
dat <- nc %>% hyper_tibble()
glimpse(dat)
# and get the correct times (in intelligible units)
time_ref <- nc %>% activate("D0") %>% hyper_tibble()
dat <- dat %>% left_join(time_ref,by=join_by(Time)) %>% 
  mutate(t=as_datetime(ot,origin=as.Date("1970-01-01"))) %>% 
  mutate(date=date(t))

# like, where does one particle go? in two dimensions
dat %>% filter(Particle==1) %>% 
  ggplot(aes(lon,lat,color=t))+
  geom_line()+
  scale_color_viridis(option="A")


