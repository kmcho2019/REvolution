module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

  // Define state encoding
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  parameter FALL = 2'b10;
  parameter DIG = 2'b11;
  
  // Declare state and next_state variables
  reg [1:0] state, next_state;
  
  // Outputs default values
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == FALL);
  assign digging = (state == DIG);
  
  // Implement the state machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  // Define the next state logic
  always @* begin
    next_state = state;
    
    case (state)
      WALK_LEFT: begin
        if (bump_right) begin
          next_state = WALK_RIGHT;
        end
        else if (dig && ground) begin
          next_state = DIG;
        end
        else if (!ground) begin
          next_state = FALL;
        end
      end
      
      WALK_RIGHT: begin
        if (bump_left) begin
          next_state = WALK_LEFT;
        end
        else if (dig && ground) begin
          next_state = DIG;
        end
        else if (!ground) begin
          next_state = FALL;
        end
      end
      
      FALL: begin
        if (ground) begin
          if (state == WALK_LEFT) begin
            next_state = WALK_LEFT;
          end
          else if (state == WALK_RIGHT) begin
            next_state = WALK_RIGHT;
          end
          else if (dig) begin
            next_state = DIG;
          end
          else begin
            next_state = WALK_LEFT;  // Default to WALK_LEFT
          end
        end
      end
      
      DIG: begin
        if (!ground) begin
          next_state = FALL;
        end
        else if (!dig) begin
          if (state == WALK_LEFT) begin
            next_state = WALK_LEFT;
          end
          else begin
            next_state = WALK_RIGHT;
          end
        end
      end
    endcase
  end
  
endmodule