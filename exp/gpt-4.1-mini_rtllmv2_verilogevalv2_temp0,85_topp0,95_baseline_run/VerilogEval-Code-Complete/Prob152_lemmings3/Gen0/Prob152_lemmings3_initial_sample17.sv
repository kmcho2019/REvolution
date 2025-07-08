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
    WALK_LEFT  = 3'b000,
    WALK_RIGHT = 3'b001,
    FALL_LEFT  = 3'b010,
    FALL_RIGHT = 3'b011,
    DIG_LEFT   = 3'b100,
    DIG_RIGHT  = 3'b101
  } state_t;

  state_t state, next_state;

  // Extract direction and activity info from states
  wire walking  = (state == WALK_LEFT) || (state == WALK_RIGHT);
  wire falling  = (state == FALL_LEFT) || (state == FALL_RIGHT);
  wire digging_s= (state == DIG_LEFT) || (state == DIG_RIGHT);
  wire dir_left = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
  wire dir_right= (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);

  // Next state logic
  always_comb begin
    next_state = state; // default hold

    // Precedence: fall > dig > direction switch
    if (!ground) begin
      // falling state - maintain direction
      if (dir_left)
        next_state = FALL_LEFT;
      else
        next_state = FALL_RIGHT;
    end else begin
      // ground present
      if (falling) begin
        // land and resume walking same direction
        if (dir_left)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end else if (digging_s) begin
        // still digging as long as ground present
        next_state = state;
      end else if (walking) begin
        // walking on ground
        if (dig) begin
          // start digging if dig=1
          if (dir_left)
            next_state = DIG_LEFT;
          else
            next_state = DIG_RIGHT;
        end else begin
          // check bumps to switch direction if any
          if (bump_left || bump_right) begin
            if (dir_left)
              next_state = WALK_RIGHT;
            else
              next_state = WALK_LEFT;
          end else begin
            next_state = state;
          end
        end
      end else begin
        // unexpected but hold state
        next_state = state;
      end
    end
  end

  // State flip-flops with async posedge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Outputs - Moore style
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule