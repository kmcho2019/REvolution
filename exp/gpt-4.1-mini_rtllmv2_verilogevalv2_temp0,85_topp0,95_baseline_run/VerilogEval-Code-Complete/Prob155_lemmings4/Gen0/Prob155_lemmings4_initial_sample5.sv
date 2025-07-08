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
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5,
    SPLATTERED = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall duration counter (up to >20)
  logic [4:0] fall_count; // 5 bits to count up to 31

  // FSM state register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      // fall_count update
      if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
        if (state == FALL_LEFT || state == FALL_RIGHT)
          fall_count <= fall_count + 1;
        else
          fall_count <= 5'd1; // start counting fall when entering falling state
      end else begin
        fall_count <= 5'd0; // reset counter if not falling
      end
    end
  end

  // Next state logic
  always_comb begin
    next_state = state; // default to hold state

    case(state)
      SPLATTERED: begin
        // Once splattered, stays splattered forever until reset
        next_state = SPLATTERED;
      end

      WALK_LEFT: begin
        if (!ground) begin
          // Fall has highest precedence
          next_state = FALL_LEFT;
        end else if (dig) begin
          // Digging if on ground and dig asserted
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // If bumped on either side, switch direction
          // bump_left or bump_right causes switch from left to right
          next_state = WALK_RIGHT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          // bump causes switch from right to left
          next_state = WALK_LEFT;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          // On landing, check if splatter or resume walking
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_LEFT;
          end
        end else begin
          // continue falling
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground) begin
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      DIG_LEFT: begin
        if (!ground) begin
          // Ground disappeared, start falling but maintain direction
          next_state = FALL_LEFT;
        end else begin
          // Continue digging (ignoring bump and dig inputs)
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else begin
          next_state = DIG_RIGHT;
        end
      end

      default: begin
        // Shouldn't happen, fallback to walk left
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Outputs - Moore FSM: purely combinational from current state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule