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
  typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5
  } state_t;

  state_t state, next_state;

  // State register with asynchronous positive edge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    // Default next state is current state
    next_state = state;

    // Extract direction from state
    logic walking_left;
    walking_left = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);

    // Priority: fall > dig > bump > stay

    // Falling conditions
    if (ground == 0) begin
      // If currently walking or digging and ground disappears, start falling
      if ((state == WALK_LEFT) || (state == WALK_RIGHT) || (state == DIG_LEFT) || (state == DIG_RIGHT)) begin
        if (walking_left)
          next_state = FALL_LEFT;
        else
          next_state = FALL_RIGHT;
      end
      // If already falling, stay falling
      else if ((state == FALL_LEFT) || (state == FALL_RIGHT)) begin
        next_state = state;
      end
    end else begin
      // ground == 1

      // If falling and ground reappears, go back to walking same direction
      if ((state == FALL_LEFT) || (state == FALL_RIGHT)) begin
        if (walking_left)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end
      // If digging and ground disappears, start falling (already handled above)
      // If digging and ground present, continue digging
      else if ((state == DIG_LEFT) || (state == DIG_RIGHT)) begin
        next_state = state;
      end
      // If walking and dig=1, start digging
      else if ((state == WALK_LEFT) || (state == WALK_RIGHT)) begin
        if (dig) begin
          if (walking_left)
            next_state = DIG_LEFT;
          else
            next_state = DIG_RIGHT;
        end else begin
          // If bumped, switch direction
          if (bump_left && bump_right) begin
            // Both bumps, switch direction
            if (walking_left)
              next_state = WALK_RIGHT;
            else
              next_state = WALK_LEFT;
          end else if (bump_left) begin
            // Bumped on left, walk right
            next_state = WALK_RIGHT;
          end else if (bump_right) begin
            // Bumped on right, walk left
            next_state = WALK_LEFT;
          end else begin
            // No bump, stay walking same direction
            next_state = state;
          end
        end
      end
    end
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule