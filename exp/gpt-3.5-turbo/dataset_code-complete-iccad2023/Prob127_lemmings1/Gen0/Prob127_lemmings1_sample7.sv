module LemmingsFSM (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

  // Define states
  parameter STATE_WALK_LEFT = 1'b0;
  parameter STATE_WALK_RIGHT = 1'b1;

  // Define internal state register
  reg state_reg, next_state;

  // Define the Moore output
  always @(*)
    case (state_reg)
      STATE_WALK_LEFT: begin
        walk_left = 1;
        walk_right = 0;
      end
      STATE_WALK_RIGHT: begin
        walk_left = 0;
        walk_right = 1;
      end
    endcase

  // State transition logic
  always @(posedge clk or posedge areset)
    if (areset)
      state_reg <= STATE_WALK_LEFT;
    else
      state_reg <= next_state;

  // Next state logic
  always @(*)
    case (state_reg)
      STATE_WALK_LEFT: begin
        if (bump_left && bump_right)
          next_state = STATE_WALK_RIGHT;
        else if (bump_left)
          next_state = STATE_WALK_RIGHT;
        else
          next_state = STATE_WALK_LEFT;
      end
      STATE_WALK_RIGHT: begin
        if (bump_left && bump_right)
          next_state = STATE_WALK_LEFT;
        else if (bump_right)
          next_state = STATE_WALK_LEFT;
        else
          next_state = STATE_WALK_RIGHT;
      end
    endcase

endmodule

module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

  LemmingsFSM lemmings_fsm (
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .walk_left(walk_left),
    .walk_right(walk_right)
  );

endmodule