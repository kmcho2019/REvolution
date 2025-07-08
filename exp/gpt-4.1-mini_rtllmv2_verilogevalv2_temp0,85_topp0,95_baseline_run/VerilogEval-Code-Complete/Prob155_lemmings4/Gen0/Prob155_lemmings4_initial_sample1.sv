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

  // State encoding (one-hot)
  localparam WALK_LEFT    = 7'b0000001;
  localparam WALK_RIGHT   = 7'b0000010;
  localparam FALLING_LEFT = 7'b0000100;
  localparam FALLING_RIGHT= 7'b0001000;
  localparam DIGGING_LEFT = 7'b0010000;
  localparam DIGGING_RIGHT= 7'b0100000;
  localparam SPLATTERED   = 7'b1000000;

  reg [6:0] state, next_state;

  // Falling counter counts how many cycles spent falling
  reg [5:0] fall_count; // 6 bits to count up to >20 (max 63)
  reg fall_exceeded;    // indicates falling time >20

  // Determine if bumped on either side
  wire bumped = bump_left | bump_right;

  // To simplify direction switching:
  // If bumped on left => walk right
  // If bumped on right => walk left
  // If bumped both sides same cycle => still switch direction (either way)
  // So if bumped, switch direction. If bump_left=1 => next walk right, else walk left.

  // Output signals derived from state
  assign walk_left  = (state == WALK_LEFT) || (state == DIGGING_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIGGING_RIGHT);
  assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);
  assign digging    = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

  // Sequential logic: State and fall_count update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 0;
      fall_exceeded <= 0;
    end else begin
      state <= next_state;

      // fall_count logic:
      // If current state is falling, increment count
      // Else reset count and fall_exceeded
      if (state == FALLING_LEFT || state == FALLING_RIGHT) begin
        // Increment fall_count if not exceeded yet
        if (!fall_exceeded) begin
          if (fall_count == 6'd21) begin
            fall_exceeded <= 1'b1;
          end else begin
            fall_count <= fall_count + 1'b1;
          end
        end
      end else begin
        fall_count <= 0;
        fall_exceeded <= 0;
      end
    end
  end

  // Combinational logic: Next state logic
  always @(*) begin
    // Default next_state is current state
    next_state = state;

    case (state)
      WALK_LEFT: begin
        // Priority: fall > dig > bump
        if (!ground) begin
          next_state = FALLING_LEFT;
        end else if (dig) begin
          next_state = DIGGING_LEFT;
        end else if (bumped) begin
          // switch direction depending on bump side
          // bumped left -> walk right
          // bumped right -> walk left
          if (bump_left) begin
            next_state = WALK_RIGHT;
          end else if (bump_right) begin
            next_state = WALK_RIGHT; // switch to walk right if bumped left or right both
            // Actually spec says if bumped on left => walk right
            // If bumped on right => walk left. So if bumped right while walk_left, walk left? no switch.
            // Let's re-check:

            // In problem:
            // "If a Lemming is bumped on the left (bump_left=1) it walks right"
            // "If bumped on right (bump_right=1) it walks left"
            // Since currently walking left:
            // - bumped left => walk right (switch)
            // - bumped right => walk left (no switch)
            // So switch direction only if bumped on left, else stay walking left

            // So if bumped_right only (and not bump_left), remain walk_left
            // If bump_left=1, switch to walk_right

            // Because bumped = bump_left | bump_right
            // So here if bumped, but bump_left=0 and bump_right=1, stay WALK_LEFT

            // So let's fix this logic:
            next_state = WALK_LEFT; // no switch if only bump_right
          end else begin
            // bumped both sides: switch direction
            // but both bump_left and bump_right=1
            // in that case, bump_left=1 triggers walk_right
            // so walk_right
            // Already handled by bump_left=1 branch
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        // Priority: fall > dig > bump
        if (!ground) begin
          next_state = FALLING_RIGHT;
        end else if (dig) begin
          next_state = DIGGING_RIGHT;
        end else if (bumped) begin
          // same logic as above, now walking right
          // bumped left => walk right (no switch)
          // bumped right => walk left (switch)
          if (bump_right) begin
            next_state = WALK_LEFT;
          end else if (bump_left) begin
            next_state = WALK_RIGHT;
          end else begin
            // bumped both sides
            // both bump_left=1 and bump_right=1
            // follow bump_left=1 => walk right (no switch)
            // bump_right=1 => walk left (switch)
            // If both, still switch directions according to problem.
            // "If it's bumped on both sides at the same time, it will still switch directions."
            // So switch direction
            // current is walk_right, switch to walk_left
            next_state = WALK_LEFT;
          end
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALLING_LEFT: begin
        // Falling continues until ground=1
        if (ground) begin
          // If fell for >20 cycles, splatter
          if (fall_exceeded) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_LEFT;
          end
        end else begin
          next_state = FALLING_LEFT;
        end
      end

      FALLING_RIGHT: begin
        if (ground) begin
          if (fall_exceeded) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = FALLING_RIGHT;
        end
      end

      DIGGING_LEFT: begin
        // Digging continues while ground=1
        // If ground disappears, go to falling left
        if (!ground) begin
          next_state = FALLING_LEFT;
        end else begin
          next_state = DIGGING_LEFT;
        end
      end

      DIGGING_RIGHT: begin
        if (!ground) begin
          next_state = FALLING_RIGHT;
        end else begin
          next_state = DIGGING_RIGHT;
        end
      end

      SPLATTERED: begin
        // remain splattered forever until reset
        next_state = SPLATTERED;
      end

      default: begin
        // Should never happen, reset to WALK_LEFT
        next_state = WALK_LEFT;
      end
    endcase
  end

endmodule