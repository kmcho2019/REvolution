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
    SPLATTERED = 3'd0,
    WALK_LEFT  = 3'd1,
    WALK_RIGHT = 3'd2,
    DIG_LEFT   = 3'd3,
    DIG_RIGHT  = 3'd4,
    FALL_LEFT  = 3'd5,
    FALL_RIGHT = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall duration counter (5 bits to count up to at least 21)
  logic [4:0] fall_count, next_fall_count;

  // Asynchronous reset and state register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      fall_count <= next_fall_count;
    end
  end

  // Next state and counter logic
  always_comb begin
    // Default next state and count
    next_state = state;
    next_fall_count = fall_count;

    case(state)
      SPLATTERED: begin
        // Remain splattered forever
        next_state = SPLATTERED;
        next_fall_count = 5'd0;
      end

      WALK_LEFT: begin
        next_fall_count = 5'd0; // not falling
        if (ground == 1) begin
          if (dig == 1) begin
            // Start digging only if on ground and not falling
            next_state = DIG_LEFT;
          end else if (bump_left == 1 || bump_right == 1) begin
            // Bumped: switch direction
            next_state = WALK_RIGHT;
          end else begin
            next_state = WALK_LEFT;
          end
        end else begin
          // ground == 0 -> fall
          next_state = FALL_LEFT;
          next_fall_count = 5'd1;
        end
      end

      WALK_RIGHT: begin
        next_fall_count = 5'd0;
        if (ground == 1) begin
          if (dig == 1) begin
            next_state = DIG_RIGHT;
          end else if (bump_left == 1 || bump_right == 1) begin
            next_state = WALK_LEFT;
          end else begin
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end
      end

      DIG_LEFT: begin
        next_fall_count = 5'd0;
        if (ground == 1) begin
          // Continue digging
          next_state = DIG_LEFT;
        end else begin
          // ground lost, start falling from dig
          next_state = FALL_LEFT;
          next_fall_count = 5'd1;
        end
      end

      DIG_RIGHT: begin
        next_fall_count = 5'd0;
        if (ground == 1) begin
          next_state = DIG_RIGHT;
        end else begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end
      end

      FALL_LEFT: begin
        if (ground == 0) begin
          // still falling, increment counter (saturate at 31)
          if (fall_count < 5'd31)
            next_fall_count = fall_count + 1;
          else
            next_fall_count = fall_count;
          next_state = FALL_LEFT;
        end else begin
          // landed on ground, check fall time
          if (fall_count > 5'd20) begin
            // splatter
            next_state = SPLATTERED;
            next_fall_count = 5'd0;
          end else begin
            // resume walking left after falling
            next_state = WALK_LEFT;
            next_fall_count = 5'd0;
          end
        end
      end

      FALL_RIGHT: begin
        if (ground == 0) begin
          if (fall_count < 5'd31)
            next_fall_count = fall_count + 1;
          else
            next_fall_count = fall_count;
          next_state = FALL_RIGHT;
        end else begin
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
            next_fall_count = 5'd0;
          end else begin
            next_state = WALK_RIGHT;
            next_fall_count = 5'd0;
          end
        end
      end

      default: begin
        next_state = WALK_LEFT;
        next_fall_count = 5'd0;
      end
    endcase
  end

  // Outputs depend only on state (Moore)
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule