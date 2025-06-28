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
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  parameter FALLING = 2'b10;
  
  // State registers
  reg [1:0] state, next_state;
  
  // Moore output logic
  always @*
    case (state)
      WALK_LEFT:
        begin
          walk_left = 1;
          walk_right = 0;
          aaah = (ground == 0) ? 1 : 0;
        end
      WALK_RIGHT:
        begin
          walk_left = 0;
          walk_right = 1;
          aaah = (ground == 0) ? 1 : 0;
        end
      FALLING:
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
      state <= WALK_LEFT;
    else
      state <= next_state;
  end
  
  always @*
    case (state)
      WALK_LEFT:
        next_state = (bump_right && !bump_left) ? WALK_RIGHT :
                     (ground == 0) ? FALLING :
                     WALK_LEFT;
      WALK_RIGHT:
        next_state = (bump_left && !bump_right) ? WALK_LEFT :
                     (ground == 0) ? FALLING :
                     WALK_RIGHT;
      FALLING:
        next_state = (ground == 1) ? ((state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT) : FALLING;
    endcase
  
endmodule