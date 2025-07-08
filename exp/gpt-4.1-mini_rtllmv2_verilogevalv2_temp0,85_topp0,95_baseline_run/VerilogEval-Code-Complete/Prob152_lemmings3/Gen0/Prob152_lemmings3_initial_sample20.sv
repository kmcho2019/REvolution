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

  // Current walking direction stored implicitly in state:
  // WALK_LEFT, FALL_LEFT, DIG_LEFT => left
  // WALK_RIGHT, FALL_RIGHT, DIG_RIGHT => right

  // Synchronous state transitions and asynchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic: Moore FSM, priority: fall > dig > bump > stay
  always_comb begin
    next_state = state; // default hold state

    // extract walking direction and whether falling/digging
    logic walking_left, walking_right;
    logic falling, digging_state;

    walking_left  = (state == WALK_LEFT)  || (state == FALL_LEFT)  || (state == DIG_LEFT);
    walking_right = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);

    falling       = (state == FALL_LEFT)  || (state == FALL_RIGHT);
    digging_state = (state == DIG_LEFT)   || (state == DIG_RIGHT);

    // Priority 1: falling
    if (!ground) begin
      // If not already falling, start falling with current walking direction
      if (!falling) begin
        if (walking_left)
          next_state = FALL_LEFT;
        else if (walking_right)
          next_state = FALL_RIGHT;
      end else begin
        // continue falling
        next_state = state;
      end
    end else begin
      // ground = 1
      if (falling) begin
        // stop falling, resume walking in same direction
        if (state == FALL_LEFT)
          next_state = WALK_LEFT;
        else // FALL_RIGHT
          next_state = WALK_RIGHT;
      end else if (digging_state) begin
        // currently digging
        // continue digging if ground=1
        next_state = state;
      end else begin
        // walking on ground
        // Priority 2: dig if dig=1 and ground=1 and not falling
        if (dig) begin
          if (walking_left)
            next_state = DIG_LEFT;
          else if (walking_right)
            next_state = DIG_RIGHT;
        end else begin
          // Priority 3: bump to switch direction if not falling or digging
          // If bumped on either side, switch direction
          if (bump_left || bump_right) begin
            if (walking_left)
              next_state = WALK_RIGHT;
            else if (walking_right)
              next_state = WALK_LEFT;
          end else begin
            // no bump, no dig, no fall -> keep walking same direction
            next_state = state;
          end
        end
      end
    end
  end

  // Outputs (Moore): only one walk direction at a time
  assign walk_left  = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule