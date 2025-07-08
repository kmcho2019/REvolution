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
  localparam SPLAT      = 3'd6;

  reg [2:0] state, next_state;

  // Fall counter - counts cycles spent falling
  reg [4:0] fall_count; // 5 bits to count up to >20

  // Determine if bumped on either side
  wire bumped;
  assign bumped = bump_left | bump_right;

  // Next state logic
  always @(*) begin
    next_state = state; // default hold

    case(state)
      WALK_LEFT: begin
        if (ground == 0) begin
          // Ground gone: start falling left
          next_state = FALL_LEFT;
        end else if (dig == 1) begin
          // Start digging left only if on ground and not falling
          next_state = DIG_LEFT;
        end else if (bumped) begin
          // Switch direction on bump while walking
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 0) begin
          // Start falling right
          next_state = FALL_RIGHT;
        end else if (dig == 1) begin
          // Start digging right
          next_state = DIG_RIGHT;
        end else if (bumped) begin
          // Switch direction on bump
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALL_LEFT: begin
        if (ground == 0) begin
          // Continue falling left
          next_state = FALL_LEFT;
        end else begin
          // Landed on ground
          if (fall_count > 20) begin
            // Too long falling => splat
            next_state = SPLAT;
          end else begin
            // Resume walking left
            next_state = WALK_LEFT;
          end
        end
      end

      FALL_RIGHT: begin
        if (ground == 0) begin
          // Continue falling right
          next_state = FALL_RIGHT;
        end else begin
          // Landed
          if (fall_count > 20) begin
            next_state = SPLAT;
          end else begin
            next_state = WALK_RIGHT;
          end
        end
      end

      DIG_LEFT: begin
        if (ground == 1) begin
          // Continue digging left
          next_state = DIG_LEFT;
        end else begin
          // ground=0 => start falling left
          next_state = FALL_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (ground == 1) begin
          // Continue digging right
          next_state = DIG_RIGHT;
        end else begin
          // ground=0 => start falling right
          next_state = FALL_RIGHT;
        end
      end

      SPLAT: begin
        // Stay splatted forever until reset
        next_state = SPLAT;
      end

      default: begin
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Sequential state update and fall count management
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      // Update state
      state <= next_state;

      // Manage fall_count
      case(next_state)
        FALL_LEFT, FALL_RIGHT: begin
          // Increment fall_count each cycle falling
          fall_count <= fall_count + 5'd1;
        end
        default: begin
          // Reset fall count when not falling
          fall_count <= 5'd0;
        end
      endcase
    end
  end

  // Output logic - Moore outputs from current state (not next_state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule