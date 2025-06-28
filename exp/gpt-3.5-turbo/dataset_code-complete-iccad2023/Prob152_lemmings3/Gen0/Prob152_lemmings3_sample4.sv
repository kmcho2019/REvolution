module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  // Define states
  reg [3:0] state, next_state;

  // Define state parameters
  parameter WALK_LEFT = 4'b0001;
  parameter WALK_RIGHT = 4'b0010;
  parameter FALLING = 4'b0100;
  parameter DIGGING = 4'b1000;

  // Define state register
  always @(posedge clk) begin
    if (areset == 1) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  // Define next state logic
  always @* begin
    next_state = state;
    aaah = 0;
    digging = 0;

    case(state)
      WALK_LEFT:
        begin
          walk_left = 1;
          walk_right = 0;
          if (dig == 1 && ground == 1) begin
            next_state = DIGGING;
            digging = 1;
          end else if (ground == 0) begin
            next_state = FALLING;
            aaah = 1;
          end else if (bump_right == 1) begin
            next_state = WALK_RIGHT;
          end
        end
      WALK_RIGHT:
        begin
          walk_left = 0;
          walk_right = 1;
          if (dig == 1 && ground == 1) begin
            next_state = DIGGING;
            digging = 1;
          end else if (ground == 0) begin
            next_state = FALLING;
            aaah = 1;
          end else if (bump_left == 1) begin
            next_state = WALK_LEFT;
          end
        end
      FALLING:
        begin
          walk_left = (state == WALK_LEFT) ? 1 : 0;
          walk_right = (state == WALK_RIGHT) ? 1 : 0;
          if (ground == 1) begin
            next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
          end
        end
      DIGGING:
        begin
          walk_left = (state == WALK_LEFT) ? 1 : 0;
          walk_right = (state == WALK_RIGHT) ? 1 : 0;
          if (ground == 0) begin
            next_state = FALLING;
          end
        end
    endcase
  end
endmodule