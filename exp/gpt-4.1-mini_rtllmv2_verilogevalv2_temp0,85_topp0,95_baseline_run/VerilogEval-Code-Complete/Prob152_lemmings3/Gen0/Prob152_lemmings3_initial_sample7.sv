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
  localparam WALK_LEFT    = 3'd0;
  localparam WALK_RIGHT   = 3'd1;
  localparam FALLING_LEFT = 3'd2;
  localparam FALLING_RIGHT= 3'd3;
  localparam DIGGING_LEFT = 3'd4;
  localparam DIGGING_RIGHT= 3'd5;

  reg [2:0] state, next_state;

  // Async reset and state transition
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end

  // Next state logic with precedence: fall > dig > bump
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (ground == 0) begin
          // Fall overrides everything
          next_state = FALLING_LEFT;
        end else if (dig == 1) begin
          // Start digging if on ground
          next_state = DIGGING_LEFT;
        end else if (bump_left == 1 || bump_right == 1) begin
          // Switch direction on bump
          // Bumped either side switches direction
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
        end else if (dig == 1) begin
          next_state = DIGGING_RIGHT;
        end else if (bump_left == 1 || bump_right == 1) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALLING_LEFT: begin
        // Ignore bumps and dig while falling
        if (ground == 1)
          next_state = WALK_LEFT;
        else
          next_state = FALLING_LEFT;
      end

      FALLING_RIGHT: begin
        if (ground == 1)
          next_state = WALK_RIGHT;
        else
          next_state = FALLING_RIGHT;
      end

      DIGGING_LEFT: begin
        // If ground lost during digging, start falling
        if (ground == 0)
          next_state = FALLING_LEFT;
        else
          next_state = DIGGING_LEFT;  // continue digging
      end

      DIGGING_RIGHT: begin
        if (ground == 0)
          next_state = FALLING_RIGHT;
        else
          next_state = DIGGING_RIGHT;
      end

      default: next_state = WALK_LEFT; // safety fallback
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);
  assign digging    = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

endmodule