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

  // State definition
  parameter WALK_LEFT = 2'd0;
  parameter WALK_RIGHT = 2'd1;
  reg [1:0] state, next_state;

  // Moore state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always @ (*) begin
    walk_left = (state == WALK_LEFT) ? 1 : 0;
    walk_right = (state == WALK_RIGHT) ? 1 : 0;
    aaah = 0;
    next_state = state; // Default next state remains the same

    if (state == WALK_LEFT) begin
      if (bump_right || (!ground && aaah)) begin
        next_state = WALK_RIGHT;
      end
      else if (!ground) begin
        aaah = 1;
      end
    end
    else if (state == WALK_RIGHT) begin
      if (bump_left || (!ground && aaah)) begin
        next_state = WALK_LEFT;
      end
      else if (!ground) begin
        aaah = 1;
      end
    end
  end

endmodule