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
    DIG_RIGHT  = 3'd5,
    SPLAT      = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall counter
  logic [4:0] fall_count; // 5 bits to count to >20

  // Track fall_count next
  logic [4:0] fall_count_next;

  // Direction helpers
  logic walking_left;
  logic walking_right;

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

  // Asynchronous reset and state register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 0;
    end else begin
      state <= next_state;
      fall_count <= fall_count_next;
    end
  end

  // Next state logic and fall_count update
  always_comb begin
    next_state = state;
    fall_count_next = fall_count;

    // Default fall_count update
    // Increment if falling, else reset
    if (state == FALL_LEFT || state == FALL_RIGHT) begin
      fall_count_next = fall_count + 1'b1;
    end else begin
      fall_count_next = 5'd0;
    end

    case(state)
      SPLAT: begin
        // Forever splatted
        next_state = SPLAT;
      end

      WALK_LEFT: begin
        if (ground == 0) begin
          // Fall has highest priority
          next_state = FALL_LEFT;
        end else if (dig == 1) begin
          // Digging if ground and dig=1
          next_state = DIG_LEFT;
        end else begin
          // Check bumps - switching directions
          if (bump_left || bump_right) begin
            // switch direction to right
            next_state = WALK_RIGHT;
          end else begin
            next_state = WALK_LEFT;
          end
        end
      end

      WALK_RIGHT: begin
        if (ground == 0) begin
          // Fall has highest priority
          next_state = FALL_RIGHT;
        end else if (dig == 1) begin
          // Digging if ground and dig=1
          next_state = DIG_RIGHT;
        end else begin
          // Check bumps - switching directions
          if (bump_left || bump_right) begin
            // switch direction to left
            next_state = WALK_LEFT;
          end else begin
            next_state = WALK_RIGHT;
          end
        end
      end

      FALL_LEFT: begin
        if (ground == 1) begin
          // Check splatter condition
          if (fall_count > 5'd20) begin
            next_state = SPLAT;
          end else begin
            // Resume walking left
            next_state = WALK_LEFT;
          end
          // fall_count will reset on next clock
        end else begin
          // Keep falling left
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground == 1) begin
          if (fall_count > 5'd20) begin
            next_state = SPLAT;
          end else begin
            next_state = WALK_RIGHT;
          end
          // fall_count resets on next clock
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      DIG_LEFT: begin
        if (ground == 0) begin
          // Start falling left when ground disappears while digging
          next_state = FALL_LEFT;
        end else begin
          // Continue digging left
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (ground == 0) begin
          // Start falling right when ground disappears while digging
          next_state = FALL_RIGHT;
        end else begin
          // Continue digging right
          next_state = DIG_RIGHT;
        end
      end

      default: begin
        next_state = WALK_LEFT; // default safe
      end
    endcase
  end

endmodule