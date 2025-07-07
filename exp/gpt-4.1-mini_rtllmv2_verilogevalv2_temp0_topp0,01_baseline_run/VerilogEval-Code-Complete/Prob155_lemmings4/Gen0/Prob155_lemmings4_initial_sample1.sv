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
    DIG_LEFT   = 3'd2,
    DIG_RIGHT  = 3'd3,
    FALL_LEFT  = 3'd4,
    FALL_RIGHT = 3'd5,
    SPLATTER   = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall counter: counts how many cycles Lemming has been falling
  // 5 bits enough to count >20 cycles
  logic [5:0] fall_count, next_fall_count;

  // Determine if bumped on either side
  wire bumped = bump_left | bump_right;

  // Determine if bumped on left or right
  wire bump_left_only  = bump_left & ~bump_right;
  wire bump_right_only = bump_right & ~bump_left;
  wire bump_both       = bump_left & bump_right;

  // FSM next state logic
  always_comb begin
    // Default assignments
    next_state = state;
    next_fall_count = fall_count;

    case(state)
      SPLATTER: begin
        // Remain splattered forever until reset
        next_state = SPLATTER;
        next_fall_count = 0;
      end

      WALK_LEFT: begin
        if (!ground) begin
          // Fall has highest priority
          next_state = FALL_LEFT;
          next_fall_count = 1;
        end else if (dig) begin
          // Digging if on ground and dig=1
          next_state = DIG_LEFT;
          next_fall_count = 0;
        end else if (bumped) begin
          // Switch direction if bumped
          next_state = WALK_RIGHT;
          next_fall_count = 0;
        end else begin
          // Continue walking left
          next_state = WALK_LEFT;
          next_fall_count = 0;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 1;
        end else if (dig) begin
          next_state = DIG_RIGHT;
          next_fall_count = 0;
        end else if (bumped) begin
          next_state = WALK_LEFT;
          next_fall_count = 0;
        end else begin
          next_state = WALK_RIGHT;
          next_fall_count = 0;
        end
      end

      DIG_LEFT: begin
        if (!ground) begin
          // Digging ends when ground disappears, start falling
          next_state = FALL_LEFT;
          next_fall_count = 1;
        end else begin
          // Continue digging left
          next_state = DIG_LEFT;
          next_fall_count = 0;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 1;
        end else begin
          next_state = DIG_RIGHT;
          next_fall_count = 0;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          // On ground after falling, check fall duration
          if (fall_count > 20) begin
            next_state = SPLATTER;
            next_fall_count = 0;
          end else begin
            // Resume walking left
            next_state = WALK_LEFT;
            next_fall_count = 0;
          end
        end else begin
          // Continue falling, increment fall count
          next_state = FALL_LEFT;
          next_fall_count = fall_count + 1;
        end
      end

      FALL_RIGHT: begin
        if (ground) begin
          if (fall_count > 20) begin
            next_state = SPLATTER;
            next_fall_count = 0;
          end else begin
            next_state = WALK_RIGHT;
            next_fall_count = 0;
          end
        end else begin
          next_state = FALL_RIGHT;
          next_fall_count = fall_count + 1;
        end
      end

      default: begin
        // Should not happen, reset to WALK_LEFT
        next_state = WALK_LEFT;
        next_fall_count = 0;
      end
    endcase
  end

  // State and fall_count registers with asynchronous reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 0;
    end else begin
      state <= next_state;
      fall_count <= next_fall_count;
    end
  end

  // Output logic (Moore machine: outputs depend only on state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule