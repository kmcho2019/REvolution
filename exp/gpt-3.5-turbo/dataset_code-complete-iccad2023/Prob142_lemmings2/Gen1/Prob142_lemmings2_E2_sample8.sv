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
  parameter LEFT = 2'd0;
  parameter RIGHT = 2'd1;
  parameter FALLING = 2'd2;
  reg [1:0] state, next_state;

  // Moore state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always @ (*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
      LEFT: begin
        if (bump_right) begin
          next_state = RIGHT;
        end
        else if (!ground) begin
          next_state = FALLING;
          aaah = 1'b1;
        end
        else begin
          next_state = LEFT;
          walk_left = 1'b1;
        end
      end
      RIGHT: begin
        if (bump_left) begin
          next_state = LEFT;
        end
        else if (!ground) begin
          next_state = FALLING;
          aaah = 1'b1;
        end
        else begin
          next_state = RIGHT;
          walk_right = 1'b1;
        end
      end
      FALLING: begin
        if (ground) begin
          if (state == RIGHT) begin
            walk_right = 1'b1;
          end
          else begin
            walk_left = 1'b1;
          end
          next_state = (state == RIGHT) ? RIGHT : LEFT;
        end
        else begin
          next_state = FALLING;
          aaah = 1'b1;
        end
      end
    endcase
  end

endmodule