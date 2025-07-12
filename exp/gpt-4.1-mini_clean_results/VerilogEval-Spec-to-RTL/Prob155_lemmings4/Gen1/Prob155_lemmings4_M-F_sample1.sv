module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

  // Mode encoding (2 bits)
  localparam MODE_WALKING  = 2'b00;
  localparam MODE_FALLING  = 2'b01;
  localparam MODE_DIGGING  = 2'b10;
  localparam MODE_SPLATTERED = 2'b11;

  reg mode, mode_next; // mode is 2 bits, so use reg [1:0]
  reg [1:0] mode_reg, mode_next_reg; // better naming
  reg [1:0] mode_curr, mode_next;

  reg dir, dir_next; // direction: 0=left,1=right

  reg [4:0] fall_count, fall_count_next;

  // Rename to mode_curr and mode_next for clarity
  reg [1:0] mode_curr, mode_next;

  // State registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      mode_curr <= MODE_WALKING;
      dir <= 1'b0; // left
      fall_count <= 5'd0;
    end else begin
      mode_curr <= mode_next;
      dir <= dir_next;
      fall_count <= fall_count_next;
    end
  end

  // Next state and counter logic
  always @(*) begin
    // Default next values
    mode_next = mode_curr;
    dir_next = dir;
    fall_count_next = fall_count;

    // Combinational logic depends on current mode and inputs

    case (mode_curr)
      MODE_WALKING: begin
        // Priority: fall > dig > bump
        if (ground == 1'b0) begin
          // Ground lost => start falling, fall_count reset to 1 (start counting from this cycle)
          mode_next = MODE_FALLING;
          // direction stays same
          fall_count_next = 5'd1;
        end else if (dig == 1'b1) begin
          // Start digging only when walking on ground and dig=1
          mode_next = MODE_DIGGING;
          // direction stays same
          fall_count_next = 5'd0;
        end else if (bump_left || bump_right) begin
          // Switch direction on any bump (even both)
          // Only switch when walking and ground=1
          // Important: bump at same time as ground=0 is ignored because fall has higher priority
          dir_next = ~dir;
          // stay in walking mode
          mode_next = MODE_WALKING;
          fall_count_next = 5'd0;
        end else begin
          // No change
          fall_count_next = 5'd0;
        end
      end

      MODE_DIGGING: begin
        // Digging continues until ground=0, then fall
        if (ground == 1'b0) begin
          mode_next = MODE_FALLING;
          fall_count_next = 5'd1;
          // direction stays same
        end else begin
          // Continue digging, ignore bumps and dig input
          mode_next = MODE_DIGGING;
          fall_count_next = 5'd0;
          // direction stays same
        end
      end

      MODE_FALLING: begin
        if (ground == 1'b0) begin
          // Still falling, increment fall count (max count saturation to avoid overflow)
          if (fall_count < 5'd31)
            fall_count_next = fall_count + 1'b1;
          else
            fall_count_next = fall_count;
          mode_next = MODE_FALLING;
          // direction stays same
        end else begin
          // Ground appeared: decide if splattered or back to walking
          if (fall_count > 5'd20) begin
            mode_next = MODE_SPLATTERED;
            fall_count_next = 5'd0;
          end else begin
            mode_next = MODE_WALKING;
            fall_count_next = 5'd0;
            // direction stays same
          end
        end
        // bumps and dig ignored in falling mode
      end

      MODE_SPLATTERED: begin
        // Stays here until reset
        mode_next = MODE_SPLATTERED;
        fall_count_next = 5'd0;
        // direction stays same (does not matter)
      end

      default: begin
        // Defensive reset to walking left
        mode_next = MODE_WALKING;
        dir_next = 1'b0;
        fall_count_next = 5'd0;
      end
    endcase
  end

  // Output logic (Moore outputs)
  always @(*) begin
    // Default outputs 0
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (mode_curr)
      MODE_WALKING: begin
        // walking output depends on direction
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
        // no walking or digging while falling
      end

      MODE_SPLATTERED: begin
        // All outputs zero
      end

      default: begin
        // Defensive default
      end
    endcase
  end

endmodule