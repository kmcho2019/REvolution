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
  parameter FALLING = 2'd2;
  reg [1:0] state, next_state;

  // Mealy state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_left <= 1'b1;
      walk_right <= 1'b0;
      aaah <= 1'b0;
    end
    else begin
      state <= next_state;
      case (state)
        WALK_LEFT: begin
          if (bump_right && !bump_left)
            next_state = WALK_RIGHT;
          else if (ground)
            next_state = WALK_LEFT;
          else
            next_state = FALLING;

          walk_left = 1'b1;
          walk_right = 1'b0;
          aaah = (ground) ? 1'b0 : 1'b1;
        end
        WALK_RIGHT: begin
          if (bump_left && !bump_right)
            next_state = WALK_LEFT;
          else if (ground)
            next_state = WALK_RIGHT;
          else
            next_state = FALLING;

          walk_left = 1'b0;
          walk_right = 1'b1;
          aaah = (ground) ? 1'b0 : 1'b1;
        end
        FALLING: begin
          if (ground)
            next_state = state;
          else
            next_state = FALLING;

          walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
          walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
          aaah = 1'b1;
        end
      endcase
    end
  end

endmodule