module LemmingsFSM (
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
  typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING
  } state_t;

  // State register
  reg [1:0] state, next_state;

  // Falling counter
  reg [4:0] fall_count;

  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      aaah <= 0;
      fall_count <= 0;
    end 
    else begin
      state <= next_state;
      fall_count <= (state == FALLING) ? fall_count + 1 : 0;
    end
  end

  always @* begin
    case (state)
      WALK_LEFT:
        begin
          walk_left = 1;
          walk_right = 0;
          if (bump_left) next_state = WALK_RIGHT;
          else if (!ground) next_state = FALLING;
          else if (dig) next_state = DIGGING;
        end
      WALK_RIGHT:
        begin
          walk_left = 0;
          walk_right = 1;
          if (bump_right) next_state = WALK_LEFT;
          else if (!ground) next_state = FALLING;
          else if (dig) next_state = DIGGING;
        end
      FALLING:
        begin
          walk_left = 0;
          walk_right = 0;
          aaah = 1;
          if (ground && fall_count >= 20) begin
            next_state = WALK_LEFT;
            aaah = 0;
          end
          else if (ground) next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
        end
      DIGGING:
        begin
          walk_left = 0;
          walk_right = 0;
          digging = 1;
          if (!ground) next_state = FALLING;
          else next_state = DIGGING; // Continue digging
        end
      default:
        begin
          walk_left = 0;
          walk_right = 0;
          aaah = 0;
          digging = 0;
          next_state = WALK_LEFT; // Reset to default state
        end
    endcase
  end

endmodule