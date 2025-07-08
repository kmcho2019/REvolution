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
    SPLATTERED  = 3'd0,
    WALK_LEFT   = 3'd1,
    WALK_RIGHT  = 3'd2,
    FALL_LEFT   = 3'd3,
    FALL_RIGHT  = 3'd4,
    DIG_LEFT    = 3'd5,
    DIG_RIGHT   = 3'd6
  } state_t;

  state_t state, next_state;
  logic [4:0] fall_count, next_fall_count; // 5-bit to count up to at least 20

  // Determine outputs based on state (Moore)
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

  // Extract walking direction from state for reuse
  logic walking_left_dir;
  always_comb begin
    case(state)
      WALK_LEFT, FALL_LEFT, DIG_LEFT: walking_left_dir = 1'b1;
      WALK_RIGHT, FALL_RIGHT, DIG_RIGHT: walking_left_dir = 1'b0;
      default: walking_left_dir = 1'b0; // for splattered, arbitrary
    endcase
  end

  // Next state logic
  always_comb begin
    // default next state and fall count
    next_state = state;
    next_fall_count = fall_count;

    case(state)

      SPLATTERED: begin
        // no transitions out except reset
        next_state = SPLATTERED;
        next_fall_count = fall_count;
      end

      // Walking states
      WALK_LEFT: begin
        // Priority: fall > dig > direction switch
        if (!ground) begin
          next_state = FALL_LEFT;
          next_fall_count = 5'd1; // start counting fall
        end else if (dig) begin
          // dig only if on ground and not falling
          next_state = DIG_LEFT;
          next_fall_count = 5'd0;
        end else if (bump_left || bump_right) begin
          // bump either side causes switch direction
          // walking left + bump => walk right
          next_state = WALK_RIGHT;
          next_fall_count = 5'd0;
        end else begin
          next_state = WALK_LEFT;
          next_fall_count = 5'd0;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end else if (dig) begin
          next_state = DIG_RIGHT;
          next_fall_count = 5'd0;
        end else if (bump_left || bump_right) begin
          // walking right + bump => walk left
          next_state = WALK_LEFT;
          next_fall_count = 5'd0;
        end else begin
          next_state = WALK_RIGHT;
          next_fall_count = 5'd0;
        end
      end

      // Falling states
      FALL_LEFT: begin
        if (!ground) begin
          // continue falling
          next_state = FALL_LEFT;
          if (fall_count == 5'd31) // saturate count to max 31
            next_fall_count = 5'd31;
          else
            next_fall_count = fall_count + 5'd1;
        end else begin
          // hit ground: check fall count for splatter
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
            next_fall_count = 5'd0;
          end else begin
            // resume walking in same direction
            next_state = WALK_LEFT;
            next_fall_count = 5'd0;
          end
        end
      end

      FALL_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          if (fall_count == 5'd31)
            next_fall_count = 5'd31;
          else
            next_fall_count = fall_count + 5'd1;
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

      // Digging states
      DIG_LEFT: begin
        // dig only while ground=1 and not falling
        if (!ground) begin
          // no ground => fall in same direction
          next_state = FALL_LEFT;
          next_fall_count = 5'd1;
        end else begin
          // continue digging ignoring bumps and dig input
          next_state = DIG_LEFT;
          next_fall_count = 5'd0;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end else begin
          next_state = DIG_RIGHT;
          next_fall_count = 5'd0;
        end
      end

      default: begin
        // Shouldn't happen, but default to walking left
        next_state = WALK_LEFT;
        next_fall_count = 5'd0;
      end

    endcase
  end

  // State register update with async reset (posedge)
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      fall_count <= next_fall_count;
    end
  end

endmodule