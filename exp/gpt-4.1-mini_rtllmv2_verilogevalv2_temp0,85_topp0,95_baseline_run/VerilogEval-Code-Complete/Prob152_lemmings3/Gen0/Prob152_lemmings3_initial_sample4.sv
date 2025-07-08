module TopModule (
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

  typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5
  } state_t;

  state_t state, next_state;

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      WALK_LEFT: begin
        if (!ground) begin
          // Fall overrides dig and bump
          next_state = FALL_LEFT;
        end else if (dig) begin
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch direction if bumped left or right
          // even if both bumped simultaneously
          next_state = WALK_RIGHT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          next_state = WALK_LEFT;
        end
        // else remain falling, bumps/dig ignored
      end

      FALL_RIGHT: begin
        if (ground) begin
          next_state = WALK_RIGHT;
        end
        // else remain falling
      end

      DIG_LEFT: begin
        if (!ground) begin
          next_state = FALL_LEFT;
        end
        // else continue digging
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end
        // else continue digging
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // State update with async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  // Outputs depend on state (Moore outputs)
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule