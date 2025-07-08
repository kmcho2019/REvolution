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

  typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    DIGGING    = 2'b10,
    FALLING    = 2'b11
  } state_t;

  state_t state, next_state;

  // Walking direction memory to resume after falling
  // 0 = left, 1 = right
  logic walk_dir; 

  // Asynchronous reset and synchronous state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // Update walk_dir only when walking or starting to walk
      if (next_state == WALK_LEFT)
        walk_dir <= 1'b0;
      else if (next_state == WALK_RIGHT)
        walk_dir <= 1'b1;
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;

    case (state)
      WALK_LEFT, WALK_RIGHT: begin
        // Priority: fall > dig > bump switch
        if (ground == 0) begin
          next_state = FALLING;
        end else if (dig) begin
          next_state = DIGGING;
        end else begin
          // Check bumps to switch walking direction
          // If bumped left => walk right
          // If bumped right => walk left
          // If both bumped, still switch directions (toggle)
          if (bump_left && bump_right) begin
            // toggle direction
            next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
          end else if (bump_left) begin
            next_state = WALK_RIGHT;
          end else if (bump_right) begin
            next_state = WALK_LEFT;
          end else begin
            next_state = state;
          end
        end
      end

      DIGGING: begin
        // While digging, ignore bumps and dig commands.
        // If ground disappears, start falling
        if (ground == 0) begin
          next_state = FALLING;
        end else begin
          // Continue digging while ground present
          next_state = DIGGING;
        end
      end

      FALLING: begin
        // While falling ignore bumps and dig commands.
        // When ground returns, resume walking in stored direction
        if (ground == 1) begin
          next_state = (walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs depend only on state (Moore FSM)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);
  assign digging    = (state == DIGGING);

endmodule