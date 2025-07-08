module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output walk_left,
  output walk_right,
  output aaah
);

  // State encoding
  typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10
  } state_t;

  state_t state, next_state;
  state_t last_walk_dir; // remembers last walking direction before falling

  // State register with asynchronous positive edge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_walk_dir <= WALK_LEFT;
    end else begin
      state <= next_state;
      // update last_walk_dir only if walking state
      if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
        last_walk_dir <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;

    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          // start falling, remember current walking dir
          next_state = FALLING;
        end else begin
          // on ground, check bumps
          if (bump_left || bump_right) begin
            // if bumped left or right or both, switch to walk_right
            next_state = WALK_RIGHT;
          end
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          // start falling
          next_state = FALLING;
        end else begin
          if (bump_left || bump_right) begin
            // switch to walk_left on any bump
            next_state = WALK_LEFT;
          end
        end
      end

      FALLING: begin
        if (ground) begin
          // ground reappeared, resume last walking direction
          next_state = last_walk_dir;
        end else begin
          // remain falling, bumps ignored
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore outputs)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule