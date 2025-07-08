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
  localparam WALK_LEFT  = 2'd0;
  localparam WALK_RIGHT = 2'd1;
  localparam FALLING    = 2'd2;

  reg [1:0] state, next_state;
  reg last_walk_dir; // 0 = left, 1 = right, stores walking direction before falling

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_walk_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // Update last_walk_dir only when walking states are active, not falling
      if (state != FALLING) begin
        last_walk_dir <= (state == WALK_RIGHT);
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default next state is current state
    next_state = state;
    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // bump flips direction
          next_state = WALK_RIGHT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // bump flips direction
          next_state = WALK_LEFT;
        end
      end

      FALLING: begin
        if (ground) begin
          // return to last walking direction
          next_state = last_walk_dir ? WALK_RIGHT : WALK_LEFT;
        end
        // bumps ignored in falling, no change on bumps
      end
    endcase
  end

  // Outputs (Moore outputs depend on state)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule