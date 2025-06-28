module LemmingFSM (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

  // Define states
  parameter Walking_Left = 2'b00;
  parameter Walking_Right = 2'b01;
  parameter Falling = 2'b10;
  
  // Define state register and next state logic
  reg [1:0] state, next_state;
  
  // Moore output logic
  always @*
    case (state)
      Walking_Left:
        begin
          walk_left = 1;
          walk_right = 0;
          aaah = 0;
        end
      Walking_Right:
        begin
          walk_left = 0;
          walk_right = 1;
          aaah = 0;
        end
      Falling:
        begin
          walk_left = state[0];
          walk_right = ~state[0];
          aaah = 1;
        end
    endcase

  // State transition logic
  always @(posedge clk or posedge areset)
  begin
    if (areset)
      state <= Walking_Left;
    else
      state <= next_state;
  end
  
  always @*
    case (state)
      Walking_Left:
        next_state = (bump_right) ? Walking_Right :
                     (ground == 0) ? Falling :
                     Walking_Left;
      Walking_Right:
        next_state = (bump_left) ? Walking_Left :
                     (ground == 0) ? Falling :
                     Walking_Right;
      Falling:
        next_state = (ground == 1) ? ((state == Walking_Left) ? Walking_Left : Walking_Right) : Falling;
    endcase
  
endmodule