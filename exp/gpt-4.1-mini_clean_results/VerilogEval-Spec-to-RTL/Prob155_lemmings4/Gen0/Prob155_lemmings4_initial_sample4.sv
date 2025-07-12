module TopModule(
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

// State encoding
typedef enum logic [2:0] {
  WALK_LEFT = 3'd0,
  WALK_RIGHT = 3'd1,
  DIG_LEFT = 3'd2,
  DIG_RIGHT = 3'd3,
  FALL_LEFT = 3'd4,
  FALL_RIGHT = 3'd5,
  SPLAT = 3'd6
} state_t;

state_t state, next_state;

// Fall counter
reg [4:0] fall_counter; // needs to count up to >20, 5 bits enough

// Determine if bumped
wire bumped = bump_left | bump_right;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
    fall_counter <= 0;
  end else begin
    state <= next_state;
    // Manage fall counter
    if (state == FALL_LEFT || state == FALL_RIGHT) begin
      if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
        // Still falling, increment counter
        if (fall_counter != 5'd31) // avoid overflow just in case
          fall_counter <= fall_counter + 1;
      end else begin
        // Leaving falling, reset counter
        fall_counter <= 0;
      end
    end else begin
      // Not falling, reset counter
      fall_counter <= 0;
    end
  end
end

always @* begin
  // Default next state is current state
  next_state = state;

  case(state)
    SPLAT: begin
      // forever splattered
      next_state = SPLAT;
    end

    FALL_LEFT: begin
      // Falling left
      if (ground) begin
        // landed
        if (fall_counter > 5'd20)
          next_state = SPLAT;
        else
          next_state = WALK_LEFT;
      end else begin
        // still falling
        next_state = FALL_LEFT;
      end
    end

    FALL_RIGHT: begin
      // Falling right
      if (ground) begin
        if (fall_counter > 5'd20)
          next_state = SPLAT;
        else
          next_state = WALK_RIGHT;
      end else begin
        next_state = FALL_RIGHT;
      end
    end

    DIG_LEFT: begin
      // Digging left
      if (!ground) begin
        // ground disappeared, start falling
        next_state = FALL_LEFT;
      end else begin
        // still digging
        next_state = DIG_LEFT;
      end
    end

    DIG_RIGHT: begin
      // Digging right
      if (!ground) begin
        // ground disappeared, start falling
        next_state = FALL_RIGHT;
      end else begin
        next_state = DIG_RIGHT;
      end
    end

    WALK_LEFT: begin
      if (!ground) begin
        // ground disappeared, start falling
        next_state = FALL_LEFT;
      end else if (dig) begin
        // start digging
        next_state = DIG_LEFT;
      end else if (bumped) begin
        // switch direction if bumped (bump left or right or both)
        next_state = WALK_RIGHT;
      end else begin
        next_state = WALK_LEFT;
      end
    end

    WALK_RIGHT: begin
      if (!ground) begin
        // ground disappeared, start falling
        next_state = FALL_RIGHT;
      end else if (dig) begin
        next_state = DIG_RIGHT;
      end else if (bumped) begin
        next_state = WALK_LEFT;
      end else begin
        next_state = WALK_RIGHT;
      end
    end

    default: begin
      // Default fallback, shouldn't occur
      next_state = WALK_LEFT;
    end
  endcase
end

// Output logic: Moore machine, outputs depend only on current state
always @* begin
  walk_left = 0;
  walk_right = 0;
  aaah = 0;
  digging = 0;

  case(state)
    WALK_LEFT: begin
      walk_left = 1;
    end
    WALK_RIGHT: begin
      walk_right = 1;
    end
    DIG_LEFT: begin
      walk_left = 1;
      digging = 1;
    end
    DIG_RIGHT: begin
      walk_right = 1;
      digging = 1;
    end
    FALL_LEFT: begin
      aaah = 1;
    end
    FALL_RIGHT: begin
      aaah = 1;
    end
    SPLAT: begin
      // all outputs zero
      walk_left = 0;
      walk_right = 0;
      aaah = 0;
      digging = 0;
    end
  endcase
end

endmodule