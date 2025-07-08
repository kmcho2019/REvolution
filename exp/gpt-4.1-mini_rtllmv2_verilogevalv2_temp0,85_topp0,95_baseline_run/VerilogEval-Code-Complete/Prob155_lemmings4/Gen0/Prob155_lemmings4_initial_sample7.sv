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
  localparam WALK_LEFT  = 3'd0,
             WALK_RIGHT = 3'd1,
             FALLING    = 3'd2,
             DIGGING    = 3'd3,
             SPLATTERED = 3'd4;

  reg [2:0] state, next_state;
  reg dir; // 0 = left, 1 = right
  reg [4:0] fall_count; // counts fall cycles up to >20

  // Output regs for Moore outputs
  reg walk_left_r, walk_right_r, aaah_r, digging_r;

  // Asynchronous reset and state update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      dir <= 1'b0; // left
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      // fall_count management
      if (state == FALLING) begin
        if (fall_count == 5'd31) // saturate at max count
          fall_count <= 5'd31;
        else
          fall_count <= fall_count + 1'b1;
      end else begin
        fall_count <= 5'd0;
      end

      // dir update:
      // Update dir on walking states or when changing walking direction,
      // or keep dir during FALLING and DIGGING
      case (next_state)
        WALK_LEFT: dir <= 1'b0;
        WALK_RIGHT: dir <= 1'b1;
        FALLING,
        DIGGING,
        SPLATTERED: dir <= dir; // keep previous direction during fall/dig/splatter
      endcase
    end
  end

  // Next state logic and direction switching logic
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
      SPLATTERED: begin
        // terminal state, no change
        next_state = SPLATTERED;
      end

      FALLING: begin
        // If ground appears, check fall_count to splatter or resume walking
        if (ground) begin
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            // resume walking in stored dir
            next_state = (dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
          end
        end else begin
          // continue falling
          next_state = FALLING;
        end
      end

      DIGGING: begin
        // If ground disappears, start falling
        if (!ground) begin
          next_state = FALLING;
        end else begin
          // continue digging
          next_state = DIGGING;
        end
      end

      WALK_LEFT,
      WALK_RIGHT: begin
        // priority: fall > dig > bump (switch direction)
        if (!ground) begin
          // start falling, store dir
          next_state = FALLING;
        end else if (dig) begin
          // start digging only if walking on ground
          next_state = DIGGING;
        end else begin
          // check bumps to switch direction
          // bumped on left or right (or both) switch direction
          if (bump_left || bump_right) begin
            if (state == WALK_LEFT)
              next_state = WALK_RIGHT;
            else // state == WALK_RIGHT
              next_state = WALK_LEFT;
          end else begin
            // keep walking same direction
            next_state = state;
          end
        end
      end

      default: begin
        // Should not happen - fallback to WALK_LEFT
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Output logic (Moore outputs depend on current state)
  always @(*) begin
    // default outputs
    walk_left_r = 1'b0;
    walk_right_r = 1'b0;
    aaah_r = 1'b0;
    digging_r = 1'b0;

    case(state)
      WALK_LEFT:  walk_left_r = 1'b1;
      WALK_RIGHT: walk_right_r = 1'b1;
      FALLING:    aaah_r = 1'b1;
      DIGGING:    digging_r = 1'b1;
      SPLATTERED: begin
        // all outputs zero
        walk_left_r = 1'b0;
        walk_right_r = 1'b0;
        aaah_r = 1'b0;
        digging_r = 1'b0;
      end
    endcase
  end

  assign walk_left = walk_left_r;
  assign walk_right = walk_right_r;
  assign aaah = aaah_r;
  assign digging = digging_r;

endmodule