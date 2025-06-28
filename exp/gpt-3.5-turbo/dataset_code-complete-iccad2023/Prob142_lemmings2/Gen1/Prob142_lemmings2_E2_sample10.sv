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
  parameter LEFT = 1'b0;
  reg state, next_state;

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
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    
    // State transitions
    case (state)
      LEFT: begin
        if (bump_right) begin
          next_state = 1'b1;
        end
        else if (!ground && (next_state != RIGHT)) begin
          aaah = 1'b1;
        end
        else if (ground && (state == 1'b0)) begin
          walk_left = 1'b1;
        end
      end
      RIGHT: begin
        if (bump_left) begin
          next_state = 1'b0;
        end
        else if (!ground && (next_state != LEFT)) begin
          aaah = 1'b1;
        end
        else if (ground && (state == 1'b1)) begin
          walk_right = 1'b1;
        end
      end
    endcase
  end

endmodule