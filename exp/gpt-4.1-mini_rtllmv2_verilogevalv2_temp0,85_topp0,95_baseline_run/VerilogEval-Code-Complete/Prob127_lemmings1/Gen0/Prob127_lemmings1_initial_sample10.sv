module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // State encoding
  localparam WALK_LEFT  = 1'b0;
  localparam WALK_RIGHT = 1'b1;

  reg state, next_state;

  // Asynchronous reset and synchronous state update
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        // If bumped on left or right, switch to walk right
        if (bump_left || bump_right)
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        // If bumped on left or right, switch to walk left
        if (bump_left || bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs depend only on state (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule