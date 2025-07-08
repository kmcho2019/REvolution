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

  // State encoding
  localparam WALK_LEFT  = 2'b00,
             WALK_RIGHT = 2'b01,
             FALLING    = 2'b10,
             DIGGING    = 2'b11;

  reg [1:0] state, next_state;
  reg walking_dir; // 0 = left, 1 = right (for resuming after falling)

  // Synchronous state register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walking_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // Update walking_dir only when walking left or right
      if (next_state == WALK_LEFT)
        walking_dir <= 1'b0;
      else if (next_state == WALK_RIGHT)
        walking_dir <= 1'b1;
    end
  end

  // Next state logic
  always @(*) begin
    // Default
    next_state = state;

    case (state)
      FALLING: begin
        if (ground) begin
          // Resume walking in previous direction
          next_state = walking_dir ? WALK_RIGHT : WALK_LEFT;
        end else begin
          // Continue falling
          next_state = FALLING;
        end
      end

      DIGGING: begin
        if (ground == 0) begin
          // Fall after digging off the ledge
          next_state = FALLING;
        end else begin
          // Continue digging
          next_state = DIGGING;
        end
      end

      WALK_LEFT, WALK_RIGHT: begin
        // Precedence: fall > dig > bump

        if (ground == 0) begin
          // Fall if no ground
          next_state = FALLING;
        end else if (dig && ground == 1) begin
          // Start digging only if walking on ground and dig=1
          next_state = DIGGING;
        end else begin
          // Check bumps to switch direction
          // Any bump switches direction
          if (bump_left || bump_right) begin
            if (state == WALK_LEFT)
              next_state = WALK_RIGHT;
            else
              next_state = WALK_LEFT;
          end else begin
            next_state = state; // remain
          end
        end
      end

      default: next_state = WALK_LEFT; // Should not occur
    endcase
  end

  // Outputs depend only on current state (Moore FSM)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);
  assign digging    = (state == DIGGING);

endmodule