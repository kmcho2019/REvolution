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
  // State encoding
  typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10,
    DIGGING    = 2'b11
  } state_t;

  state_t state, next_state;

  // We need to remember walking direction before falling or digging.
  // For FALLING and DIGGING states, the walking direction is stored in a separate variable.
  logic prev_walk_left; // 1 means walking left, 0 means walking right

  // State register and prev_walk_left register with asynchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      prev_walk_left <= 1'b1; // walking left on reset
    end else begin
      state <= next_state;
      // Update prev_walk_left only when transitioning into WALK_LEFT or WALK_RIGHT, or when starting FALLING or DIGGING
      // Actually, better to update prev_walk_left when we enter WALK_LEFT or WALK_RIGHT, or when starting FALLING or DIGGING from walking
      if ((next_state == WALK_LEFT) || (next_state == WALK_RIGHT)) begin
        prev_walk_left <= (next_state == WALK_LEFT);
      end else if ((state == WALK_LEFT || state == WALK_RIGHT) && (next_state == FALLING)) begin
        prev_walk_left <= (state == WALK_LEFT);
      end else if ((state == WALK_LEFT || state == WALK_RIGHT) && (next_state == DIGGING)) begin
        prev_walk_left <= (state == WALK_LEFT);
      end
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case(state)
      WALK_LEFT: begin
        // Priority: fall > dig > bump
        if (!ground) begin
          next_state = FALLING;
        end else if (dig) begin
          next_state = DIGGING;
        end else if (bump_left || bump_right) begin
          // bump left or right switches direction
          next_state = WALK_RIGHT;
        end
      end
      WALK_RIGHT: begin
        // Priority: fall > dig > bump
        if (!ground) begin
          next_state = FALLING;
        end else if (dig) begin
          next_state = DIGGING;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end
      end
      FALLING: begin
        // Falling continues until ground appears
        if (ground) begin
          // Resume walking in previous direction
          next_state = prev_walk_left ? WALK_LEFT : WALK_RIGHT;
        end
        // else remain falling
      end
      DIGGING: begin
        // Digging continues until ground disappears, then falls
        if (!ground) begin
          next_state = FALLING;
        end
        // else remain digging
      end
      default: next_state = WALK_LEFT; // default fallback
    endcase
  end

  // Output logic (Moore machine: outputs depend only on state)
  assign walk_left  = (state == WALK_LEFT) || (state == DIGGING && prev_walk_left);
  assign walk_right = (state == WALK_RIGHT) || (state == DIGGING && !prev_walk_left);
  assign aaah       = (state == FALLING);
  assign digging    = (state == DIGGING);

endmodule