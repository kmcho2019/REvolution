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
  parameter RIGHT = 1'b1;
  reg state, next_state;

  // Moore state machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    
    case (state)
      LEFT: begin
        // State transitions
        if (!ground) begin
          aaah = 1'b1;
        end
        else if (bump_right) begin
          next_state = RIGHT;
        end
        else begin
          next_state = LEFT;
          walk_left = 1'b1;
        end
      end
      RIGHT: begin
        // State transitions
        if (!ground) begin
          aaah = 1'b1;
        end
        else if (bump_left) begin
          next_state = LEFT;
        end
        else begin
          next_state = RIGHT;
          walk_right = 1'b1;
        end
      end
    endcase
  end

endmodule