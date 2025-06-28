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
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  parameter FALLING = 2'b10;
  
  reg [1:0] state, next_state;
  
  // Mealy state machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  // Next state logic and output assignments
  always @* begin
    walk_left = (state == WALK_LEFT);
    walk_right = (state == WALK_RIGHT);
    
    case (state)
      WALK_LEFT: begin
        if (bump_right) begin
          next_state = WALK_RIGHT;
        end
        else if (ground == 0) begin
          next_state = FALLING;
        end
        else begin
          next_state = WALK_LEFT;
        end
      end
      WALK_RIGHT: begin
        if (bump_left) begin
          next_state = WALK_LEFT;
        end
        else if (ground == 0) begin
          next_state = FALLING;
        end
        else begin
          next_state = WALK_RIGHT;
        end
      end
      FALLING: begin
        if (ground == 1) begin
          if (state == WALK_LEFT) begin
            next_state = WALK_LEFT;
          end
          else begin
            next_state = WALK_RIGHT;
          end
        end
        else begin
          next_state = FALLING;
        end
      end
    endcase
    aaah = (state == FALLING && ground == 0);
  end

endmodule