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
  state_t last_walk_state; // remembers walking direction before falling

  // Asynchronous reset and state register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      // Update last_walk_state only when walking (not falling)
      if (ground && (state == WALK_LEFT || state == WALK_RIGHT))
        last_walk_state <= state;
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
          // switch direction on bump
          next_state = WALK_RIGHT;
        end
      end
      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // switch direction on bump
          next_state = WALK_LEFT;
        end
      end
      FALLING: begin
        if (ground) begin
          // resume walking in last direction before falling
          next_state = last_walk_state;
        end
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule