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
  state_t prev_walk_state; // remembers walking direction before falling

  // State register with asynchronous active-high reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      prev_walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      // Update prev_walk_state when walking and ground lost
      if ((state == WALK_LEFT || state == WALK_RIGHT) && ground && next_state == FALLING)
        prev_walk_state <= state;
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case (state)
      WALK_LEFT: begin
        if (!ground)
          next_state = FALLING;
        else if (bump_left || bump_right)
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      end

      WALK_RIGHT: begin
        if (!ground)
          next_state = FALLING;
        else if (bump_left || bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end

      FALLING: begin
        if (ground)
          next_state = prev_walk_state;
        else
          next_state = FALLING;
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore machine: output depends only on current state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule