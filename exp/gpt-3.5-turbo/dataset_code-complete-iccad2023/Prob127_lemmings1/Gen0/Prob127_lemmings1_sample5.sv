module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

  // Define states
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  
  // State and output signals
  reg [1:0] state, next_state;
  reg walk_left, walk_right;
  
  // Moore state machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end 
    else begin
      state <= next_state;
    end
  end
  
  always @* begin
    case(state)
      WALK_LEFT: begin
        if(bump_right)
          next_state = WALK_LEFT;
        else if(bump_left)
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if(bump_left)
          next_state = WALK_RIGHT;
        else if(bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end
    endcase
  end
  
  // Output assignment
  always @* begin
    case(state)
      WALK_LEFT: begin
        walk_left = 1;
        walk_right = 0;
      end
      WALK_RIGHT: begin
        walk_left = 0;
        walk_right = 1;
      end
    endcase
  end

endmodule