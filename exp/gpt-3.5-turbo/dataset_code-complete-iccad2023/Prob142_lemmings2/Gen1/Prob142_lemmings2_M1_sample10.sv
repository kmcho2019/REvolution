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
  reg [1:0] state, next_state;

  // Mealy state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  // State transitions
  always @ (*) begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    
    case (state)
      LEFT: begin
        if (bump_right) begin
          next_state = RIGHT;
        end
        else if (!ground) begin
          aaah = 1'b1;
        end
        else if (ground && !bump_left) begin
          walk_left = 1'b1;
        end
      end
      RIGHT: begin
        if (bump_left) begin
          next_state = LEFT;
        end
        else if (!ground) begin
          aaah = 1'b1;
        end
        else if (ground && !bump_right) begin
          walk_right = 1'b1;
        end
      end
    endcase
  end

endmodule