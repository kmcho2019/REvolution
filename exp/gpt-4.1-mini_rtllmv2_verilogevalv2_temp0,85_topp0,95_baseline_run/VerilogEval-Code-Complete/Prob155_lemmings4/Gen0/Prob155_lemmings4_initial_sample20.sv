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
    W_LEFT = 3'd0,
    W_RIGHT = 3'd1,
    FALL_LEFT = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT = 3'd4,
    DIG_RIGHT = 3'd5,
    SPLAT = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall counter
  logic [4:0] fall_count; // counts up to 31, enough for 20 cycles

  // Next fall count logic
  logic [4:0] next_fall_count;

  // Determine if bumped on any side
  wire bumped = bump_left | bump_right;

  // Internal signals for walking direction
  logic walking_left;

  // Output assignments based on state (Moore outputs)
  assign walk_left  = (state == W_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == W_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

  // Synchronous state transition and fall_count update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= W_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      fall_count <= next_fall_count;
    end
  end

  // Combinational logic for next state and fall counter
  always_comb begin
    // Default assignments
    next_state = state;
    next_fall_count = fall_count;

    case(state)
      W_LEFT: begin
        // priority: fall > dig > bump
        if (!ground) begin
          // fall starts, reset fall_count to 1
          next_state = FALL_LEFT;
          next_fall_count = 5'd1;
        end else if (dig) begin
          next_state = DIG_LEFT;
          // fall_count stays zero
          next_fall_count = 5'd0;
        end else if (bumped) begin
          // switch direction if bumped on left or right or both
          // bump left while walking left means switch right
          // bump right while walking left means switch right (still switch)
          next_state = W_RIGHT;
          next_fall_count = 5'd0;
        end else begin
          // stay walking left
          next_state = W_LEFT;
          next_fall_count = 5'd0;
        end
      end

      W_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end else if (dig) begin
          next_state = DIG_RIGHT;
          next_fall_count = 5'd0;
        end else if (bumped) begin
          // bump left or right while walking right causes switch left
          next_state = W_LEFT;
          next_fall_count = 5'd0;
        end else begin
          next_state = W_RIGHT;
          next_fall_count = 5'd0;
        end
      end

      FALL_LEFT: begin
        if (!ground) begin
          // keep falling, increment fall count but saturate at max 31
          if (fall_count < 5'd31)
            next_fall_count = fall_count + 5'd1;
          else
            next_fall_count = 5'd31;
          next_state = FALL_LEFT;
        end else begin
          // hit ground after falling
          // if fall_count > 20 splatter
          if (fall_count > 5'd20) begin
            next_state = SPLAT;
            next_fall_count = 5'd0;
          end else begin
            // resume walking left as before fall
            next_state = W_LEFT;
            next_fall_count = 5'd0;
          end
        end
      end

      FALL_RIGHT: begin
        if (!ground) begin
          // keep falling, increment fall count saturate at 31
          if (fall_count < 5'd31)
            next_fall_count = fall_count + 5'd1;
          else
            next_fall_count = 5'd31;
          next_state = FALL_RIGHT;
        end else begin
          if (fall_count > 5'd20) begin
            next_state = SPLAT;
            next_fall_count = 5'd0;
          end else begin
            next_state = W_RIGHT;
            next_fall_count = 5'd0;
          end
        end
      end

      DIG_LEFT: begin
        if (!ground) begin
          // ground disappeared, start falling, fall_count=1
          next_state = FALL_LEFT;
          next_fall_count = 5'd1;
        end else begin
          // keep digging ignoring bumps and dig input
          next_state = DIG_LEFT;
          next_fall_count = 5'd0;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
          next_fall_count = 5'd1;
        end else begin
          next_state = DIG_RIGHT;
          next_fall_count = 5'd0;
        end
      end

      SPLAT: begin
        // terminal state, no transitions
        next_state = SPLAT;
        next_fall_count = 5'd0;
      end

      default: begin
        // should not occur, but reset to walk left
        next_state = W_LEFT;
        next_fall_count = 5'd0;
      end
    endcase
  end

endmodule