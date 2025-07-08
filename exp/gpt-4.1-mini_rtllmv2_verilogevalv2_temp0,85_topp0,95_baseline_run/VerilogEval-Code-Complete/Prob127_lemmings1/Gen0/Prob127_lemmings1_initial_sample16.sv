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

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: 
        if (bump_left || bump_right)
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      WALK_RIGHT:
        if (bump_left || bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      default:
        next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore machine outputs depend only on state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);

endmodule