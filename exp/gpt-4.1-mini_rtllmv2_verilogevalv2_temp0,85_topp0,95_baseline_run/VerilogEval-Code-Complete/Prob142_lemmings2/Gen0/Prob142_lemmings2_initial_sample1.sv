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

  // Registers to remember walking direction before falling
  state_t walk_state;

  // Asynchronous reset and state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
        walk_state <= next_state; // update last walking direction
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // switch direction
          next_state = WALK_RIGHT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // switch direction
          next_state = WALK_LEFT;
        end
      end

      FALLING: begin
        if (ground) begin
          // resume walking in previous direction
          next_state = walk_state;
        end
        // bumps ignored while falling
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule