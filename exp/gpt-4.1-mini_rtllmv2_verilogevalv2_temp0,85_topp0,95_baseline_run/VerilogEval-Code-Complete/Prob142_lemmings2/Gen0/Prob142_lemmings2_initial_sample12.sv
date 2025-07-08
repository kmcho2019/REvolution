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
    WALK_LEFT  = 2'd0,
    WALK_RIGHT = 2'd1,
    FALLING    = 2'd2
  } state_t;

  state_t state, next_state;

  // To remember walking direction before falling
  state_t saved_walk_state;

  // Asynchronous reset, posedge triggered
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      saved_walk_state <= WALK_LEFT;
    end else begin
      state <= next_state;
      // Update saved_walk_state only when on ground and walking
      if (ground && (next_state == WALK_LEFT || next_state == WALK_RIGHT)) begin
        saved_walk_state <= next_state;
      end
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
          // bump on either side switches direction
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end
      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end
      FALLING: begin
        if (ground) begin
          // Return to saved walking state when ground returns
          next_state = saved_walk_state;
        end else begin
          next_state = FALLING;
        end
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs: Moore outputs depend only on state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule