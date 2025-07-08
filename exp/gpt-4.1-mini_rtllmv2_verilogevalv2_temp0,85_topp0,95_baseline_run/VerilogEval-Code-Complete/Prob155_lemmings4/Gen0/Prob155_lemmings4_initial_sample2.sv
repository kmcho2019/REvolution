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
    WALK_L    = 3'd0,
    WALK_R    = 3'd1,
    FALL_L    = 3'd2,
    FALL_R    = 3'd3,
    DIG_L     = 3'd4,
    DIG_R     = 3'd5,
    SPLATTER  = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall counter: counts how many cycles the Lemming has been falling
  logic [4:0] fall_count; // 5 bits to count beyond 20 (max 31)

  // Determine if bumped on either side
  wire bumped = bump_left | bump_right;

  // State registers and fall counter register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_L;
      fall_count <= 0;
    end else begin
      state <= next_state;
      // Update fall_count in falling states, reset otherwise
      if (state == FALL_L || state == FALL_R) begin
        if (ground) begin
          fall_count <= 0; // Reset count on ground
        end else begin
          fall_count <= fall_count + 1;
        end
      end else begin
        fall_count <= 0;
      end
    end
  end

  // Next state logic (Moore FSM)
  always_comb begin
    // Default next state is current state
    next_state = state;

    case(state)
      WALK_L: begin
        if (!ground) begin
          // Fall has highest priority
          next_state = FALL_L;
        end else if (dig) begin
          // Dig second priority, only if ground=1 and walking
          next_state = DIG_L;
        end else if (bumped) begin
          // Switch direction
          next_state = WALK_R;
        end else begin
          next_state = WALK_L;
        end
      end

      WALK_R: begin
        if (!ground) begin
          next_state = FALL_R;
        end else if (dig) begin
          next_state = DIG_R;
        end else if (bumped) begin
          next_state = WALK_L;
        end else begin
          next_state = WALK_R;
        end
      end

      FALL_L: begin
        if (ground) begin
          // Ground appeared, check fall count for splatter
          if (fall_count > 5'd20) begin
            next_state = SPLATTER;
          end else begin
            // Resume walking left
            next_state = WALK_L;
          end
        end else begin
          next_state = FALL_L;
        end
      end

      FALL_R: begin
        if (ground) begin
          if (fall_count > 5'd20) begin
            next_state = SPLATTER;
          end else begin
            next_state = WALK_R;
          end
        end else begin
          next_state = FALL_R;
        end
      end

      DIG_L: begin
        if (!ground) begin
          // Start falling after digging ends (ground disappeared)
          next_state = FALL_L;
        end else begin
          // Continue digging if ground still present
          next_state = DIG_L;
        end
      end

      DIG_R: begin
        if (!ground) begin
          next_state = FALL_R;
        end else begin
          next_state = DIG_R;
        end
      end

      SPLATTER: begin
        // Remain splattered forever until reset
        next_state = SPLATTER;
      end

      default: begin
        // Safety fallback: reset to WALK_L
        next_state = WALK_L;
      end
    endcase
  end

  // Outputs depend on state only (Moore outputs)
  assign walk_left  = (state == WALK_L);
  assign walk_right = (state == WALK_R);
  assign aaah       = (state == FALL_L) || (state == FALL_R);
  assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule