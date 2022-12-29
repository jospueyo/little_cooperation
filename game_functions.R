# Inspired on https://github.com/kjytay/misc/blob/master/blog/2021-01-05%20first_orchard.R

# state contains three key positions in the game
# state <- c("start" = 4, "bridge" = 0, "pillar" = 6)

# roll the dice and do the consequent action
simulate_turn <- function(state, verbose = FALSE) {
  # roll dice
  faces <- c("bridge", "home", "pillar")
  roll <- sample(faces, size = 1)

  if (roll == "bridge" && state["start"] > 0){
    state["start"] <- state["start"] - 1
    state["bridge"] <- min(state["bridge"] + 1, 4)
  } else if (roll == "home"){
    state["bridge"] <- max(state["bridge"] - 1, 0)
  } else if (roll == "pillar"){
    state["pillar"] <- state["pillar"] - 1
  }

  if (verbose)
    cat(paste("Roll:", roll, ", State:", paste(state, collapse = ",")),
        fill = TRUE)

  return(state)
}

check_game_state <- function(state) {
  if (sum(state[1:2]) == 0) {
    return(1)  # players win
  } else if (state["pillar"] < 2) {
    return(2)  # bridge collapses
  } else {
    return(3)  # game ongoing
  }
}

simulate_game <- function(verbose = FALSE) {
  # set beginning state
  state <- c("start" = 4, "bridge" = 0, "pillar" = 6)

  num_turns <- 0  # total number of turns for the game
  outcome <- check_game_state(state)
  while (outcome == 3) {
    num_turns <- num_turns + 1
    state <- simulate_turn(state, verbose = verbose)
    outcome <- check_game_state(state)
  }

  # print game info
  if (verbose) {
    cat(switch(outcome, "Players win", "Bridge collapses", "Game ongoing"),
        fill = TRUE)
    cat(paste("# of turns:", num_turns), fill = TRUE)
  }

  # return 4 interesting game stats:
  # outcome, # of turns taken, # steps raven took, # fruit left
  return(tibble::tibble(outcome = outcome,
                        num_turns = num_turns,
                        start = state["start"],
                        bridge = state["bridge"],
                        home = 4 - bridge - start,
                        pillars = state["pillar"]))
}
