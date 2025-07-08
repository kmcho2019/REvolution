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
  localparam WALK_LEFT  = 3'd0;
  localparam WALK_RIGHT = 3'd1;
  localparam FALL_LEFT  = 3'd2;
  localparam FALL_RIGHT = 3'd3;
  localparam DIG_LEFT   = 3'd4;
  localparam DIG_RIGHT  = 3'd5;
  localparam SPLATTERED = 3'd6;

  reg [2:0] state, next_state;
  reg [5:0] fall_count, next_fall_count; // 6 bits to count beyond 20

  // Sequential state and fall_count update with async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 0;
    end else begin
      state <= next_state;
      fall_count <= next_fall_count;
    end
  end

  // Next state and fall_count logic
  always @* begin
    // Default next state and fall_count
    next_state = state;
    next_fall_count = fall_count;

    // If splattered, remain splattered
    if (state == SPLATTERED) begin
      next_state = SPLATTERED;
      next_fall_count = 0;
    end else begin
      case (state)
        // Walking left
        WALK_LEFT: begin
          if (!ground) begin
            // Start falling left
            next_state = FALL_LEFT;
            next_fall_count = 1;
          end else if (dig) begin
            // Start digging left only if on ground and dig=1
            next_state = DIG_LEFT;
            next_fall_count = 0;
          end else begin
            // Not falling or digging: check bumps for direction change
            // If bumped left or right (or both), change direction
            if (bump_left || bump_right) begin
              next_state = WALK_RIGHT;
              next_fall_count = 0;
            end else begin
              next_state = WALK_LEFT;
              next_fall_count = 0;
            end
          end
        end

        // Walking right
        WALK_RIGHT: begin
          if (!ground) begin
            // Start falling right
            next_state = FALL_RIGHT;
            next_fall_count = 1;
          end else if (dig) begin
            // Start digging right
            next_state = DIG_RIGHT;
            next_fall_count = 0;
          end else begin
            // Check bumps for direction change
            if (bump_left || bump_right) begin
              next_state = WALK_LEFT;
              next_fall_count = 0;
            end else begin
              next_state = WALK_RIGHT;
              next_fall_count = 0;
            end
          end
        end

        // Falling left
        FALL_LEFT: begin
          if (ground) begin
            // Landing: check fall count for splatter
            if (fall_count > 20) begin
              next_state = SPLATTERED;
              next_fall_count = 0;
            end else begin
              // Resume walking left
              next_state = WALK_LEFT;
              next_fall_count = 0;
            end
          end else begin
            // Continue falling, increment fall count with saturate at max 63
            next_state = FALL_LEFT;
            if (fall_count < 63)
              next_fall_count = fall_count + 1;
            else
              next_fall_count = fall_count;
          end
        end

        // Falling right
        FALL_RIGHT: begin
          if (ground) begin
            if (fall_count > 20) begin
              next_state = SPLATTERED;
              next_fall_count = 0;
            end else begin
              next_state = WALK_RIGHT;
              next_fall_count = 0;
            end
          end else begin
            next_state = FALL_RIGHT;
            if (fall_count < 63)
              next_fall_count = fall_count + 1;
            else
              next_fall_count = fall_count;
          end
        end

        // Digging left
        DIG_LEFT: begin
          if (!ground) begin
            // Ground disappeared, start falling left
            next_state = FALL_LEFT;
            next_fall_count = 1;
          end else begin
            // Continue digging left
            next_state = DIG_LEFT;
            next_fall_count = 0;
          end
        end

        // Digging right
        DIG_RIGHT: begin
          if (!ground) begin
            // Ground disappeared, start falling right
            next_state = FALL_RIGHT;
            next_fall_count = 1;
          end else begin
            next_state = DIG_RIGHT;
            next_fall_count = 0;
          end
        end

        // Splattered: should not be here, handled above
        default: begin
          next_state = SPLATTERED;
          next_fall_count = 0;
        end
      endcase
    end
  end

  // Outputs are only based on current state (Moore machine)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule