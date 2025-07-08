module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // State encoding
  typedef enum logic {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
  } state_t;

  state_t state, next_state;

  // Asynchronous reset and state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) 
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    // Default: remain in current state
    next_state = state;
    if (bump_left | bump_right)
      next_state = ~state;  // Switch direction if bumped on any side
  end

  // Outputs: Moore outputs depend only on current state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule