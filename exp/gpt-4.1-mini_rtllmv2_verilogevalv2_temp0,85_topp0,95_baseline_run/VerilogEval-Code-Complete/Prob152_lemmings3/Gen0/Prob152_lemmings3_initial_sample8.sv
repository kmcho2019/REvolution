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

  // Sequential logic: state register with async positive edge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  // Combinational logic: next state logic
  always_comb begin
    next_state = state; // default stay

    // Extract current walking direction for use in falling/digging
    // For walking and digging states, direction is left if state is WALK_LEFT or DIG_LEFT
    // For falling states, direction is left if FALL_LEFT
    logic walking_left;
    walking_left = (state == WALK_LEFT) || (state == DIG_LEFT) || (state == FALL_LEFT);

    // Priority:
    // 1) Fall if ground==0 and currently walking or digging
    // 2) Dig if ground==1, not falling, dig=1, and currently walking
    // 3) Switch direction if walking and bumped (bump left or right or both)

    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALL_LEFT;
        end else if (dig) begin
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch direction to walk right if bumped on either side
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          // Switch direction to walk left
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      DIG_LEFT: begin
        if (!ground) begin
          // ground disappeared during digging, start falling left
          next_state = FALL_LEFT;
        end else begin
          // Continue digging (ignore bumps and dig)
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else begin
          next_state = DIG_RIGHT;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          // Land, resume walking left
          next_state = WALK_LEFT;
        end else begin
          // Continue falling
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground) begin
          // Land, resume walking right
          next_state = WALK_RIGHT;
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs: Moore outputs based on state
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule