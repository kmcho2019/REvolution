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
    W_LEFT  = 3'b000,  // walking left
    W_RIGHT = 3'b001,  // walking right
    FALL    = 3'b010,  // falling
    DIG_LEFT = 3'b011, // digging left
    DIG_RIGHT = 3'b100 // digging right
  } state_t;

  state_t state, next_state;

  // FSM state transitions
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= W_LEFT;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = state; // default hold

    // Determine if bumped (one or both sides)
    logic bumped;
    bumped = bump_left | bump_right;

    case (state)
      W_LEFT: begin
        if (!ground) begin
          // fall takes priority
          next_state = FALL;
        end else if (dig) begin
          next_state = DIG_LEFT;
        end else if (bumped) begin
          // switch direction
          next_state = W_RIGHT;
        end
      end

      W_RIGHT: begin
        if (!ground) begin
          next_state = FALL;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bumped) begin
          next_state = W_LEFT;
        end
      end

      DIG_LEFT: begin
        if (!ground) begin
          // ground disappeared while digging -> fall
          next_state = FALL;
        end
        // else continue digging regardless of bumps or dig input (ignored)
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL;
        end
      end

      FALL: begin
        if (ground) begin
          // ground reappeared, resume walking in previous direction
          // Direction should be remembered from before falling
          // Since we do not have explicit memory of direction, we infer it:
          // If fell from digging left or walking left -> W_LEFT
          // If fell from digging right or walking right -> W_RIGHT
          // We need to track previous walking direction before fall.

          // To track previous walking direction, store a reg during walking/digging states.
          // We'll implement this below.
          next_state = (state_fall_dir == 1'b0) ? W_LEFT : W_RIGHT;
        end
      end

      default: next_state = W_LEFT; // safety fallback
    endcase
  end

  // Track direction before falling (0=left,1=right)
  logic state_fall_dir;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state_fall_dir <= 1'b0; // left
    end else begin
      // Update fall_dir only when walking or digging
      // So that direction is remembered for falling state
      case(state)
        W_LEFT:    state_fall_dir <= 1'b0;
        DIG_LEFT:  state_fall_dir <= 1'b0;
        W_RIGHT:   state_fall_dir <= 1'b1;
        DIG_RIGHT: state_fall_dir <= 1'b1;
        default: /* no change */;
      endcase
    end
  end

  // Outputs for Moore machine, depends only on state
  assign walk_left  = (state == W_LEFT)  || (state == DIG_LEFT);
  assign walk_right = (state == W_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule