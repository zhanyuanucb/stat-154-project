divide2grid <- function(max_x, min_x, max_y, min_y, n) {
  lx = max_x - min_x
  ly = max_y - min_y
  list(c(min_x + round(lx/n)*(0:(n-1))), c(min_y + round(ly/n)*(0:(n-1))))
}

adjust_edge <- function(max_i, min_i, size=3) {
  len = max_i - min_i + 1
  adj_len = (len - (len %% 3))
  adj_max = adj_len + min_i - 1
  return(adj_max)
}

get_length <- function(img) {
  x_len = max(img$x) - min(img$x) + 1
  y_len = max(img$y) - min(img$y) + 1
  return(c(x_len, y_len))
}

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

crop_img <- function(img, filter_size=3) {
  min_y = min(img$y)
  low_x = img %>% filter(y == min_y) %>% dplyr::select(x)
  
  crop_x_low = min(low_x)
  crop_x_up = max(low_x)
  y_low = min(img$y)
  y_up = max(img$y)
  
  adj_y = adjust_edge(y_up, y_low)
  adj_x = adjust_edge(crop_x_up, crop_x_low)
  
  cropped_img <- img %>% filter(x >= crop_x_low) %>% filter(x <= adj_x)
  cropped_img <- cropped_img %>% filter(y >= y_low) %>% filter(y <= adj_y)
  return(cropped_img)
}

get_super_pixel <- function(img, region) {
  x_list = region[[1]]
  y_list = region[[2]]
  x_p = x_list[2]
  y_p = y_list[2]
  pixel_df = data.frame()
  for (x_i in x_list) {
    for (y_i in y_list) {
      pixel_xy = img %>% filter(x == x_i) %>% filter(y == y_i)
      pixel_df = rbind.data.frame(pixel_df, pixel_xy)
    }
  }
  #print(nrow(pixel_df))
  pixel_label = getmode(pixel_df$label)
  pixel_df = pixel_df %>% summarise_all(mean)
  pixel_df = pixel_df %>% mutate(x = x_p)
  pixel_df = pixel_df %>% mutate(y = y_p)
  pixel_df = pixel_df %>% mutate(label = pixel_label)
  return(pixel_df)
}

blur_img <- function(img, filter_size=3) {
  blurred_img <- data.frame()
  min_x = min(img$x)
  max_x = max(img$x)
  min_y = min(img$y)
  max_y = max(img$y)
  for (x in seq(min_x, max_x - filter_size + 1, filter_size)) {
    for (y in seq(min_y, max_y - filter_size + 1, filter_size)) {
      x_list = x:(x+filter_size-1)
      y_list = y:(y+filter_size-1)
      region = list(x_list, y_list)
      super_pixel = get_super_pixel(img, region)
      blurred_img = rbind.data.frame(blurred_img, super_pixel)
    }
  }
  return(blurred_img)
} 

cropped_img <- crop_img(m3)

ggplot(data = cropped_img) +
  geom_point(aes(x = x, y = y, color = label)) +
  ggtitle("cropped m3")

blurred_m3 <- blur_img(cropped_img)

#ggplot(data = blurred_m3) +
#  geom_point(aes(x = x, y = y, color = label)) +
#  ggtitle("blurred m3")