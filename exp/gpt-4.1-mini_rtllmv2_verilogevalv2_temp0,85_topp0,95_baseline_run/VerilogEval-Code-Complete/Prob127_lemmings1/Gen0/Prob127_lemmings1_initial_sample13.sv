module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // Define states
  typedef enum logic [0:0] {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
  } state_t;

  state_t state, next_state;

  // Asynchronous reset, synchronous state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    // Default to no change
    next_state = state;
    // If bumped on either side, toggle direction
    if (bump_left || bump_right) begin
      if (state == WALK_LEFT)
        next_state = WALK_RIGHT;
      else
        next_state = WALK_LEFT;
    end
  end

  // Output assignments based on state (Moore)
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule