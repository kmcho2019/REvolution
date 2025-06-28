module LemmingsStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

  parameter STATE_WALK_LEFT = 2'b00;
  parameter STATE_WALK_RIGHT = 2'b01;

  reg [1:0] state, next_state;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      STATE_WALK_LEFT:
        begin
          walk_left = 1;
          walk_right = 0;
          
          if (bump_left && !bump_right) begin
            next_state = STATE_WALK_RIGHT;
          end else begin
            next_state = STATE_WALK_LEFT;
          end
        end
      STATE_WALK_RIGHT:
        begin
          walk_left = 0;
          walk_right = 1;
          
          if (bump_right && !bump_left) begin
            next_state = STATE_WALK_LEFT;
          end else begin
            next_state = STATE_WALK_RIGHT;
          end
        end
    endcase
  end

endmodule