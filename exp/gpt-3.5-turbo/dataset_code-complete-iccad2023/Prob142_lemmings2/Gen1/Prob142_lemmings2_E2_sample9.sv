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
  parameter FALL = 2'd2;
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
    // Default values
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    
    case (state)
      LEFT: begin
        // State transitions
        if (bump_right) begin
          next_state = RIGHT;
        end
        else if (!ground) begin
          next_state = FALL;
          aaah = 1'b1;
        end
        else begin
          next_state = LEFT;
          walk_left = 1'b1;
        end
      end
      RIGHT: begin
        // State transitions
        if (bump_left) begin
          next_state = LEFT;
        end
        else if (!ground) begin
          next_state = FALL;
          aaah = 1'b1;
        end
        else begin
          next_state = RIGHT;
          walk_right = 1'b1;
        end
      end
      FALL: begin
        // State transition back to original walking direction when ground reappears
        if (ground) begin
          if (state == LEFT) begin
            next_state = LEFT;
            walk_left = 1'b1;
          end
          else begin
            next_state = RIGHT;
            walk_right = 1'b1;
          end
        end
        else begin
          next_state = FALL;
          aaah = 1'b1;
        end
      end
    endcase
  end

endmodule