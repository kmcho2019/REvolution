module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // State encoding
  localparam WALK_LEFT = 1'b0;
  localparam WALK_RIGHT = 1'b1;

  reg state, next_state;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    // If bumped on either side, switch directions
    if (bump_left || bump_right) begin
      next_state = ~state;
    end else begin
      next_state = state;
    end
  end

  // Outputs (Moore outputs based on state)
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule