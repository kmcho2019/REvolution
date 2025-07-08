module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  // State encoding
  typedef enum logic [2:0] {
    WALK_LEFT  = 3'b000,
    WALK_RIGHT = 3'b001,
    DIG_LEFT   = 3'b010,
    DIG_RIGHT  = 3'b011,
    FALL_LEFT  = 3'b100,
    FALL_RIGHT = 3'b101
  } state_t;

  state_t state, next_state;

  // Sequential logic for state update with async reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Combinational logic for next state
  always_comb begin
    // Default to current state
    next_state = state;

    // Extract current direction and action from state
    // direction: left if state is WALK_LEFT, DIG_LEFT, FALL_LEFT
    // direction: right if state is WALK_RIGHT, DIG_RIGHT, FALL_RIGHT
    logic walking, digging_state, falling;
    logic direction_left;
    walking      = (state == WALK_LEFT) || (state == WALK_RIGHT);
    digging_state= (state == DIG_LEFT) || (state == DIG_RIGHT);
    falling      = (state == FALL_LEFT) || (state == FALL_RIGHT);
    direction_left = (state == WALK_LEFT) || (state == DIG_LEFT) || (state == FALL_LEFT);

    // Priority of transitions: fall > dig > switch direction > stay

    if (falling) begin
      // If falling and ground returns, go back to walking in same direction
      if (ground)
        next_state = direction_left ? WALK_LEFT : WALK_RIGHT;
      else
        next_state = state; // keep falling
    end else if (digging_state) begin
      // If digging and ground lost, start falling
      if (!ground)
        next_state = direction_left ? FALL_LEFT : FALL_RIGHT;
      else
        next_state = state; // keep digging
    end else if (walking) begin
      // Check fall first
      if (!ground)
        next_state = direction_left ? FALL_LEFT : FALL_RIGHT;
      else if (dig) // start digging only if ground and walking
        next_state = direction_left ? DIG_LEFT : DIG_RIGHT;
      else begin
        // switch direction if bumped (any bump causes switch)
        if (bump_left || bump_right) begin
          // switch walking direction
          next_state = direction_left ? WALK_RIGHT : WALK_LEFT;
        end else
          next_state = state;
      end
    end else begin
      // Should not happen, but keep state if invalid
      next_state = state;
    end
  end

  // Output logic: Moore outputs depend on state only
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule