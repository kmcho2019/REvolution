module LemmingStateMachine (
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
  typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING
  } state_t;
  state_t state, next_state;

  // Output logic
  always @*
    case(state)
      WALK_LEFT: begin
        walk_left = 1;
        walk_right = 0;
        aaah = 0;
      end
      WALK_RIGHT: begin
        walk_left = 0;
        walk_right = 1;
        aaah = 0;
      end
      FALLING: begin
        walk_left = 0;
        walk_right = 0;
        aaah = 1;
      end
    endcase

  // State transition logic
  always @(posedge clk or posedge areset)
    if (areset) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end

  // Next state logic
  always @*
    case(state)
      WALK_LEFT: begin
        if (bump_right)
          next_state = WALK_RIGHT;
        else if (!ground)
          next_state = FALLING;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (bump_left)
          next_state = WALK_LEFT;
        else if (!ground)
          next_state = FALLING;
        else
          next_state = WALK_RIGHT;
      end
      FALLING: begin
        if (ground)
          next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
        else
          next_state = FALLING;
      end
    endcase

endmodule