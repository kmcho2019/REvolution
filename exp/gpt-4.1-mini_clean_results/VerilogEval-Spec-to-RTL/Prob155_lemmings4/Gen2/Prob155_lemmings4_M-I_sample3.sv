module TopModule(
  input        clk,
  input        areset,      // async active-high reset
  input        bump_left,
  input        bump_right,
  input        ground,
  input        dig,
  output reg   walk_left,
  output reg   walk_right,
  output reg   aaah,
  output reg   digging
);

  // Mode encoding (2 bits)
  localparam MODE_WALKING    = 2'b00;
  localparam MODE_FALLING    = 2'b01;
  localparam MODE_DIGGING    = 2'b10;
  localparam MODE_SPLATTERED = 2'b11;

  reg [1:0] mode_curr, mode_next; // current and next mode
  reg       dir, dir_next;         // direction: 0=left,1=right
  reg [4:0] fall_count, fall_count_next; // fall cycle counter

  // State registers with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      mode_curr   <= MODE_WALKING;
      dir         <= 1'b0;    // start walking left
      fall_count  <= 5'd0;
    end else begin
      mode_curr   <= mode_next;
      dir         <= dir_next;
      fall_count  <= fall_count_next;
    end
  end

  // Next state and counter logic
  always @(*) begin
    // Defaults: hold current state and zero fall_count by default if walking or digging
    mode_next       = mode_curr;
    dir_next        = dir;
    fall_count_next = fall_count;

    case (mode_curr)
      MODE_WALKING: begin
        // Priority: falling > digging > bump
        if (ground == 1'b0) begin
          // Start falling, reset fall_count to 1 (count this cycle)
          mode_next       = MODE_FALLING;
          fall_count_next = 5'd1;
          // direction unchanged
        end else if (dig == 1'b1) begin
          // Start digging only if on ground and walking
          mode_next       = MODE_DIGGING;
          fall_count_next = 5'd0;
          // direction unchanged
        end else if (bump_left || bump_right) begin
          // On any bump, flip direction
          dir_next        = ~dir;
          mode_next       = MODE_WALKING;
          fall_count_next = 5'd0;
        end else begin
          // Continue walking, reset fall_count
          fall_count_next = 5'd0;
        end
      end

      MODE_DIGGING: begin
        if (ground == 1'b0) begin
          // Transition from digging to falling when ground lost
          mode_next       = MODE_FALLING;
          fall_count_next = 5'd1;
          // direction unchanged
        end else begin
          // Continue digging, no change to direction or fall_count (zero)
          mode_next       = MODE_DIGGING;
          fall_count_next = 5'd0;
        end
      end

      MODE_FALLING: begin
        if (ground == 1'b0) begin
          // Still falling, increment fall_count (saturate at max 31)
          if (fall_count < 5'd31)
            fall_count_next = fall_count + 5'd1;
          else
            fall_count_next = fall_count;
          mode_next = MODE_FALLING;
          // direction unchanged
        end else begin
          // Ground reappeared: check if splattered or resume walking
          if (fall_count > 5'd20) begin
            mode_next       = MODE_SPLATTERED;
            fall_count_next = 5'd0;
          end else begin
            mode_next       = MODE_WALKING;
            fall_count_next = 5'd0;
            // direction unchanged
          end
        end
      end

      MODE_SPLATTERED: begin
        // Remain splattered forever until reset
        mode_next       = MODE_SPLATTERED;
        fall_count_next = 5'd0;
        // direction unchanged (irrelevant)
      end

      default: begin
        // Defensive default to walking left
        mode_next       = MODE_WALKING;
        dir_next        = 1'b0;
        fall_count_next = 5'd0;
      end
    endcase
  end

  // Output logic (Moore outputs depend only on current state)
  always @(*) begin
    // Default all outputs low
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;
    digging    = 1'b0;

    case (mode_curr)
      MODE_WALKING: begin
        if (dir == 1'b0)
          walk_left = 1'b1;
        else
          walk_right = 1'b1;
      end

      MODE_DIGGING: begin
        digging = 1'b1;
        if (dir == 1'b0)
          walk_left = 1'b1;
        else
          walk_right = 1'b1;
      end

      MODE_FALLING: begin
        aaah = 1'b1;
      end

      MODE_SPLATTERED: begin
        // All outputs remain 0
      end

      default: begin
        // Defensive: all outputs zero
      end
    endcase
  end

endmodule