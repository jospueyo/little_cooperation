library(tidyverse)
source("game_functions.R")

# one game to check
simulate_game(verbose = TRUE)

#####
# SIMULATION: probability of winning the game
# We allow number of fruit of each color to vary from 1 to 8,
# And the the number of steps the raven must take from 1 to 8.
#####
nsim <- 1000 # no. of simulation runs for each param setting

result <- purrr::map_dfr(1:nsim, ~ simulate_game(verbose = FALSE))

cat("Probability of win:", sum(result$outcome == 1)/nsim * 100, "%")

cat("Average of turns:", mean(result$num_turns))

# number of pillars remaining when players win
result |>
  filter(outcome == 1) |>
  ggplot(aes(x = pillars))+
  geom_density()

# number of turns regarding outcome
result |>
  mutate(outcome = if_else(outcome == 1, "Players win", "Bridge collapses")) |>
  ggplot(aes(x = outcome, y = num_turns))+
  geom_violin()+
  geom_boxplot(width = 0.1)

# where are the animals when bridge collapses
result |>
  filter(outcome == 2) |>
  pivot_longer(3:5) |>
  ggplot(aes(x=name, y=value))+
  geom_violin()
