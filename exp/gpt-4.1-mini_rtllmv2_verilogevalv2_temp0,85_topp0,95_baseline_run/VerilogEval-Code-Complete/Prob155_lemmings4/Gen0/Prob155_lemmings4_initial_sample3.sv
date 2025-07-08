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

  // Modes
  localparam MODE_WALK   = 2'd0;
  localparam MODE_FALL   = 2'd1;
  localparam MODE_DIG    = 2'd2;
  localparam MODE_SPLAT  = 2'd3;

  // Directions
  localparam DIR_LEFT  = 1'b0;
  localparam DIR_RIGHT = 1'b1;

  reg [1:0] mode, mode_next;
  reg direction, direction_next;
  reg [4:0] fall_count, fall_count_next; // 5 bits to count up to >20 cycles
  // fall_count increments only in falling mode, resets otherwise

  // State registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      mode <= MODE_WALK;
      direction <= DIR_LEFT;
      fall_count <= 5'd0;
    end else begin
      mode <= mode_next;
      direction <= direction_next;
      fall_count <= fall_count_next;
    end
  end

  // Next state logic
  always @* begin
    // Default next values
    mode_next = mode;
    direction_next = direction;
    fall_count_next = fall_count;

    case(mode)
      MODE_WALK: begin
        // Priority: fall > dig > bump
        if (ground == 0) begin
          // Start falling
          mode_next = MODE_FALL;
          // fall count starts at 1 cycle here
          fall_count_next = 5'd1;
          // direction unchanged
          direction_next = direction;
        end else if (dig == 1) begin
          // Start digging only if on ground and not falling
          mode_next = MODE_DIG;
          fall_count_next = 5'd0;
          direction_next = direction;
        end else begin
          // Walking on ground, no fall or dig
          fall_count_next = 5'd0;
          // bump changes direction
          if (bump_left || bump_right) begin
            // Switch direction regardless of which bump side (or both)
            direction_next = ~direction;
          end else begin
            direction_next = direction;
          end
          mode_next = MODE_WALK;
        end
      end

      MODE_FALL: begin
        // While falling, increment fall_count
        if (ground == 0) begin
          // Still falling, increment count (max saturation not needed)
          fall_count_next = fall_count + 1;
          // Keep mode and direction same
          mode_next = MODE_FALL;
          direction_next = direction;
        end else begin
          // Hit ground, check fall duration to splatter or walk
          if (fall_count > 5'd20) begin
            // Splatter, cease all outputs forever (until reset)
            mode_next = MODE_SPLAT;
            fall_count_next = 5'd0;
            direction_next = direction; // direction irrelevant now
          end else begin
            // Land safely, return to walking same direction
            mode_next = MODE_WALK;
            fall_count_next = 5'd0;
            direction_next = direction;
          end
        end
      end

      MODE_DIG: begin
        // Digging on ground, continue digging until ground=0 then fall
        if (ground == 0) begin
          // Start falling from dig
          mode_next = MODE_FALL;
          fall_count_next = 5'd1;
          direction_next = direction; // keep same direction
        end else begin
          // Continue digging, ignore bumps and dig signal
          mode_next = MODE_DIG;
          fall_count_next = 5'd0;
          direction_next = direction;
        end
      end

      MODE_SPLAT: begin
        // Remain splattered forever until reset
        mode_next = MODE_SPLAT;
        fall_count_next = 5'd0;
        direction_next = direction;
      end

      default: begin
        // Default to walking left on error (should never happen)
        mode_next = MODE_WALK;
        direction_next = DIR_LEFT;
        fall_count_next = 5'd0;
      end
    endcase
  end

  // Output logic (Moore outputs)
  assign walk_left  = (mode == MODE_WALK && direction == DIR_LEFT);
  assign walk_right = (mode == MODE_WALK && direction == DIR_RIGHT);
  assign aaah       = (mode == MODE_FALL);
  assign digging    = (mode == MODE_DIG);

endmodule