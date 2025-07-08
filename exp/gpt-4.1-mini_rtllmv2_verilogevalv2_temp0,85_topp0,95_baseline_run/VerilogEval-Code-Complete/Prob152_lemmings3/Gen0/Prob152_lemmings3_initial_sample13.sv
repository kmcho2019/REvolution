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
  // We use 3 bits for states
  localparam WALK_LEFT  = 3'd0;
  localparam WALK_RIGHT = 3'd1;
  localparam FALL       = 3'd2;
  localparam DIG_LEFT   = 3'd3;
  localparam DIG_RIGHT  = 3'd4;

  reg [2:0] state, next_state;

  // To remember walking direction before falling
  // 0 = left, 1 = right
  reg walk_dir; 

  // Next state logic
  always @(*) begin
    // Defaults:
    next_state = state;

    case(state)
      WALK_LEFT: begin
        // Priority: Fall > Dig > Switch direction
        if (!ground) begin
          // Start falling, remember direction
          next_state = FALL;
        end else if (dig) begin
          // Start digging left
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch direction
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALL: begin
        // When ground reappears, resume walking in stored direction
        if (ground) begin
          if (walk_dir == 0)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end else begin
          next_state = FALL;
        end
      end

      DIG_LEFT: begin
        // If ground lost, fall
        if (!ground) begin
          next_state = FALL;
        end else begin
          // Continue digging left, ignore bumps and dig commands
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL;
        end else begin
          next_state = DIG_RIGHT;
        end
      end

      default: next_state = WALK_LEFT; // default safety
    endcase
  end

  // State and walk_dir update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir <= 0;
    end else begin
      // Update walk_dir when entering WALK_LEFT or WALK_RIGHT from other states
      // Also update when switching walking direction due to bump in walking states
      if ((state == FALL || state == DIG_LEFT || state == DIG_RIGHT) && (next_state == WALK_LEFT))
        walk_dir <= 0;
      else if ((state == FALL || state == DIG_LEFT || state == DIG_RIGHT) && (next_state == WALK_RIGHT))
        walk_dir <= 1;
      else if ((state == WALK_LEFT && next_state == WALK_RIGHT) || (state == WALK_RIGHT && next_state == WALK_LEFT))
        walk_dir <= (state == WALK_LEFT) ? 1'b1 : 1'b0;

      state <= next_state;
    end
  end

  // Output logic: Moore outputs depend only on state
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == FALL);
  assign digging = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule