module TopModule (
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

  // Define states
  parameter STATE_WALK_LEFT = 2'b00;
  parameter STATE_WALK_RIGHT = 2'b01;
  parameter STATE_FALLING = 2'b10;
  parameter STATE_DIGGING = 2'b11;

  // Define current state and next state
  reg [1:0] state, next_state;

  // Define falling counter
  reg [4:0] fall_count;

  // State machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_WALK_LEFT;
      walk_left <= 1;
      walk_right <= 0;
      aaah <= 0;
      digging <= 0;
      fall_count <= 0;
    end else begin
      state <= next_state;
      case(state)
        STATE_WALK_LEFT:
          begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
            if (bump_right && ground) next_state = STATE_WALK_RIGHT;
            else if (!ground) next_state = STATE_FALLING;
            else if (dig) next_state = STATE_DIGGING;
            else next_state = STATE_WALK_LEFT;
          end
        STATE_WALK_RIGHT:
          begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
            if (bump_left && ground) next_state = STATE_WALK_LEFT;
            else if (!ground) next_state = STATE_FALLING;
            else if (dig) next_state = STATE_DIGGING;
            else next_state = STATE_WALK_RIGHT;
          end
        STATE_FALLING:
          begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
            if (ground) next_state = (state == STATE_WALK_LEFT) ? STATE_WALK_LEFT : STATE_WALK_RIGHT;
            else if (fall_count == 20) begin
              aaah <= 0;
              next_state = (state == STATE_WALK_LEFT) ? STATE_WALK_LEFT : STATE_WALK_RIGHT;
            end
            fall_count <= (fall_count == 20) ? 20 : fall_count + 1;
          end
        STATE_DIGGING:
          begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
            if (!ground) next_state = STATE_FALLING;
            else if (bump_left && ground) next_state = STATE_WALK_LEFT;
            else if (bump_right && ground) next_state = STATE_WALK_RIGHT;
            else next_state = STATE_DIGGING;
          end
        default:
          next_state = STATE_WALK_LEFT;
      endcase
    end
  end

endmodule