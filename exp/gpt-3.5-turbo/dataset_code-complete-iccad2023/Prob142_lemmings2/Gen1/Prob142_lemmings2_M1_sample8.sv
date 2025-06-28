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

  // Moore state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always @(*) begin
    aaah = 1'b0; // Default value
    
    // Falling state
    if (!ground) begin
      aaah = 1'b1;
      next_state = state; // Maintain current state while falling
    end
    else begin
      // State transitions
      case (state)
        LEFT: begin
          if (bump_right) begin
            next_state = RIGHT;
          end
          else begin
            next_state = LEFT;
          end
        end
        RIGHT: begin
          if (bump_left) begin
            next_state = LEFT;
          end
          else begin
            next_state = RIGHT;
          end
        end
      endcase
    end
  end

  always @(*) begin
    // Output assignments
    walk_left = (state == LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == RIGHT) ? 1'b1 : 1'b0;
  end

endmodule