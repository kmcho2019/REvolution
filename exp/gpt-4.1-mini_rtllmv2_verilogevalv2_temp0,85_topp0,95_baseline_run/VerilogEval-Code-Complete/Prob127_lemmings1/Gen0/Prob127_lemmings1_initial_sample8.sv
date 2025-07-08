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

  // State register with asynchronous positive edge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    if (bump_left || bump_right)
      next_state = ~state;  // switch direction if bumped on either side
    else
      next_state = state;   // stay in current state otherwise
  end

  // Output logic (Moore machine: outputs depend only on state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule