module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

  // Declare states
  typedef enum logic [1:0] {
    LEFT, RIGHT
  } state_t;
  state_t state, next_state;

  // Moore state machine with synchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  // Default assignments
  assign {walk_left, walk_right, aaah} = 3'b0;

  // State transitions and outputs
  always_comb begin
    next_state = state;
    case (state)
      LEFT: begin
        if (bump_right)
          next_state = RIGHT;
        else if (!ground)
          aaah = 1'b1;
        else if (ground)
          walk_left = 1'b1;
      end
      RIGHT: begin
        if (bump_left)
          next_state = LEFT;
        else if (!ground)
          aaah = 1'b1;
        else if (ground)
          walk_right = 1'b1;
      end
    endcase
  end

endmodule