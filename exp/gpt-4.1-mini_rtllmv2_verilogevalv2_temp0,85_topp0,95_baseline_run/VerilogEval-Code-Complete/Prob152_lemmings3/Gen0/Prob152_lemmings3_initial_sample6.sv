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
  localparam WALK_LEFT  = 3'd0;
  localparam WALK_RIGHT = 3'd1;
  localparam DIG_LEFT   = 3'd2;
  localparam DIG_RIGHT  = 3'd3;
  localparam FALL_LEFT  = 3'd4;
  localparam FALL_RIGHT = 3'd5;

  reg [2:0] state, next_state;

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
      // Walking left on ground
      WALK_LEFT: begin
        if (!ground) begin
          // Fall takes priority over dig and bump
          next_state = FALL_LEFT;
        end else if (dig) begin
          // Digging if dig asserted and on ground
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch direction if bumped
          next_state = WALK_RIGHT;
        end
      end

      // Walking right on ground
      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end
      end

      // Digging left
      DIG_LEFT: begin
        if (!ground) begin
          // When ground disappears while digging, start falling left
          next_state = FALL_LEFT;
        end else begin
          // Continue digging if ground present; bump and dig signals ignored
          next_state = DIG_LEFT;
        end
      end

      // Digging right
      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else begin
          // Continue digging if ground present
          next_state = DIG_RIGHT;
        end
      end

      // Falling left
      FALL_LEFT: begin
        if (ground) begin
          // Resume walking left after ground reappears
          next_state = WALK_LEFT;
        end else begin
          // Continue falling
          next_state = FALL_LEFT;
        end
      end

      // Falling right
      FALL_RIGHT: begin
        if (ground) begin
          next_state = WALK_RIGHT;
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      default: next_state = WALK_LEFT; // Default fallback
    endcase
  end

  // Output logic: Moore machine outputs depend on current state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule