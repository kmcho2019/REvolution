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
  typedef enum reg [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10
  } state_t;

  state_t state, next_state;
  state_t saved_walk_state; // to remember the walking state before falling

  // Asynchronous reset and state register update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      saved_walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      // Update saved_walk_state only when walking, not when falling
      if (next_state != FALLING)
        saved_walk_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
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
        // Ignore bumps in falling state
        if (ground)
          next_state = saved_walk_state;
        else
          next_state = FALLING;
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore machine: outputs depend only on state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule