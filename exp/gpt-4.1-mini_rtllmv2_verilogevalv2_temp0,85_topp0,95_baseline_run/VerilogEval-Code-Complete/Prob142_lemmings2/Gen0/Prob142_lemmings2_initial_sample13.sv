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
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALL = 2'b10
  } state_t;

  state_t state, next_state;

  // Store the walking direction before falling to resume after fall
  state_t walk_dir_before_fall;

  // Sequential logic for state and walk_dir_before_fall
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir_before_fall <= WALK_LEFT;
    end else begin
      state <= next_state;
      // Update walk_dir_before_fall only when walking, preserve during fall
      if (ground && (state == WALK_LEFT || state == WALK_RIGHT))
        walk_dir_before_fall <= state;
    end
  end

  // Combinational logic for next_state
  always_comb begin
    next_state = state;
    case (state)
      WALK_LEFT: begin
        if (!ground)
          next_state = FALL;
        else if (bump_left || bump_right)
          next_state = WALK_RIGHT;
      end
      WALK_RIGHT: begin
        if (!ground)
          next_state = FALL;
        else if (bump_left || bump_right)
          next_state = WALK_LEFT;
      end
      FALL: begin
        if (ground)
          next_state = walk_dir_before_fall;
        else
          next_state = FALL;
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs depend only on current state (Moore machine)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL);

endmodule