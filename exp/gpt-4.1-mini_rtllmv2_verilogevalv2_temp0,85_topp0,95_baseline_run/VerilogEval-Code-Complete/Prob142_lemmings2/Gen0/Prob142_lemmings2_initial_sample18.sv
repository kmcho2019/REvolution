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
  state_t last_walk_state; // remembers last walking direction before falling

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      if (state != FALLING)
        last_walk_state <= state; // update last walking direction only when not falling
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (ground == 0)
          next_state = FALLING;
        else if (bump_left || bump_right) // any bump switches direction
          next_state = WALK_RIGHT;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (ground == 0)
          next_state = FALLING;
        else if (bump_left || bump_right)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end
      FALLING: begin
        if (ground == 1)
          next_state = last_walk_state; // resume previous walking direction
        else
          next_state = FALLING;
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule