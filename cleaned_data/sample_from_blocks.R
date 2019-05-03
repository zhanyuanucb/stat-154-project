divide2grid <- function(max_x, min_x, max_y, min_y, n) {
  lx = max_x - min_x
  ly = max_y - min_y
  list(c(min_x + round(lx/n)*(0:(n-1))), c(min_y + round(ly/n)*(0:(n-1))))
}

# random seed for each image: 
# m1: 154, m3: 189, m3: 182
set.seed(182)
N <- 10 # Divide an image into N x N blocks
grid <- divide2grid(max(m3$x), min(m3$x), max(m3$y), min(m3$y), N)
x_grid = grid[[1]]
y_grid = grid[[2]]
max_x <- max(m3$x)
min_x <- min(m3$x)
max_y <- max(m3$y)
min_y <- min(m3$y)

pick_blocks <- function(x_grid, y_grid, n) {
  list(sample(x_grid, size = n, replace = FALSE), sample(y_grid, size = n, replace = FALSE))
}

block_filter <- function(x, y, x_low, x_up, y_low, y_up) {
  x %in% x_low:x_up && y %in% y_low:y_up
}

delta_x <- round((max_x - min_x)/N)
delta_y <- round((max_y - min_y)/N)
m3 <- m3 %>% mutate(index = 1:nrow(m3))

#########################################################
# Sample for testing set
#########################################################
test_sampled_blocks <- pick_blocks(x_grid, y_grid, 10)

test_x_low <- test_sampled_blocks[[1]]
test_y_low <- test_sampled_blocks[[2]]

test_x_up <- test_x_low + delta_x
test_y_up <- test_y_low + delta_y

########################################################
# Sample for validation set
########################################################
val_sampled_blocks <- pick_blocks(x_grid, y_grid, 10)

val_x_low <- val_sampled_blocks[[1]]
val_y_low <- val_sampled_blocks[[2]]

val_x_up <- val_x_low + delta_x
val_y_up <- val_y_low + delta_y
########################################################
n <- length(val_x_low)

m3_test <- data.frame()
m3_val <- data.frame()
for (i in 1:n) {
  temp <- m3 %>% filter(x %in% (test_x_low[i]:test_x_up[i])) %>% filter(y %in% (test_y_low[i]:test_y_up[i]))
  m3_test <- rbind.data.frame(m3_test, temp)
  temp <- m3 %>% filter(x %in% (val_x_low[i]:val_x_up[i])) %>% filter(y %in% (val_y_low[i]:val_y_up[i]))
  m3_val <- rbind.data.frame(m3_val, temp)
}

train_indices = (1:nrow(m3))[-c(m3_test$index, m3_val$index)]
m3_train <- m3[train_indices, ]
annotated_m3 <- rbind.data.frame(m3_test, m3_val) %>% mutate(class_label = c(rep('test', nrow(m3_test)),
                                                                             rep('val', nrow(m3_val))
))