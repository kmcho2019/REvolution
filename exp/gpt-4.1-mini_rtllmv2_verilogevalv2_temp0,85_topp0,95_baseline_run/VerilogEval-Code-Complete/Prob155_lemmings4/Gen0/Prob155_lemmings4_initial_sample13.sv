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
  typedef enum logic [2:0] {
    WALK_LEFT  = 3'd0,
    WALK_RIGHT = 3'd1,
    FALL_LEFT  = 3'd2,
    FALL_RIGHT = 3'd3,
    DIG_LEFT   = 3'd4,
    DIG_RIGHT  = 3'd5,
    SPLATTERED = 3'd6
  } state_t;

  state_t state, next_state;

  // Fall timer count
  logic [4:0] fall_counter; // max count 31, enough for 20 cycles

  // State register and fall_counter register with async reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_counter <= 5'd0;
    end else begin
      state <= next_state;

      // Update fall_counter: increment if falling, else reset
      if ((state == FALL_LEFT) || (state == FALL_RIGHT)) begin
        fall_counter <= fall_counter + 5'd1;
      end else begin
        fall_counter <= 5'd0;
      end
    end
  end

  // Next state logic
  always_comb begin
    next_state = state;
    case(state)
      WALK_LEFT: begin
        if (ground == 1'b0) begin
          // Start falling left
          next_state = FALL_LEFT;
        end else if (dig == 1'b1) begin
          // Start digging left
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch walking direction to right
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 1'b0) begin
          next_state = FALL_RIGHT;
        end else if (dig == 1'b1) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALL_LEFT: begin
        if (ground == 1'b1) begin
          // Landing
          if (fall_counter > 5'd20) begin
            // splatter
            next_state = SPLATTERED;
          end else begin
            // resume walking left
            next_state = WALK_LEFT;
          end
        end else begin
          // continue falling left
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground == 1'b1) begin
          if (fall_counter > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      DIG_LEFT: begin
        if (ground == 1'b0) begin
          // fall after digging reaches cliff
          next_state = FALL_LEFT;
        end else begin
          // continue digging left
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (ground == 1'b0) begin
          next_state = FALL_RIGHT;
        end else begin
          next_state = DIG_RIGHT;
        end
      end

      SPLATTERED: begin
        // remain splattered forever until reset
        next_state = SPLATTERED;
      end

      default: begin
        // should not happen, reset to WALK_LEFT
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Output logic (Moore outputs)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule