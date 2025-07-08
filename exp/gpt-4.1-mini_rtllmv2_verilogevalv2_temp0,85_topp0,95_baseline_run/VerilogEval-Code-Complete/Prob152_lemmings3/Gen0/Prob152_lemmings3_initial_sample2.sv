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
  localparam DIGGING_LEFT = 3'd2;
  localparam DIGGING_RIGHT= 3'd3;
  localparam FALLING_LEFT = 3'd4;
  localparam FALLING_RIGHT= 3'd5;

  reg [2:0] state, next_state;

  // Sequential state update with asynchronous positive edge reset
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
      // Walking left
      WALK_LEFT: begin
        if (ground == 0) begin
          // fall if no ground
          next_state = FALLING_LEFT;
        end else if (dig == 1) begin
          // start digging if on ground and dig asserted
          next_state = DIGGING_LEFT;
        end else if (bump_left == 1 || bump_right == 1) begin
          // switch direction on any bump
          next_state = WALK_RIGHT;
        end
        // else remain WALK_LEFT
      end

      // Walking right
      WALK_RIGHT: begin
        if (ground == 0) begin
          // fall if no ground
          next_state = FALLING_RIGHT;
        end else if (dig == 1) begin
          // start digging if on ground and dig asserted
          next_state = DIGGING_RIGHT;
        end else if (bump_left == 1 || bump_right == 1) begin
          // switch direction on any bump
          next_state = WALK_LEFT;
        end
        // else remain WALK_RIGHT
      end

      // Digging left
      DIGGING_LEFT: begin
        if (ground == 0) begin
          // fall when dig hole ends
          next_state = FALLING_LEFT;
        end
        // else remain DIGGING_LEFT
        // bumps and dig ignored while digging
      end

      // Digging right
      DIGGING_RIGHT: begin
        if (ground == 0) begin
          // fall when dig hole ends
          next_state = FALLING_RIGHT;
        end
        // else remain DIGGING_RIGHT
        // bumps and dig ignored while digging
      end

      // Falling left
      FALLING_LEFT: begin
        if (ground == 1) begin
          // resume walking left on ground
          next_state = WALK_LEFT;
        end
        // else remain FALLING_LEFT
        // bumps and dig ignored while falling
      end

      // Falling right
      FALLING_RIGHT: begin
        if (ground == 1) begin
          // resume walking right on ground
          next_state = WALK_RIGHT;
        end
        // else remain FALLING_RIGHT
      end

      default: next_state = WALK_LEFT; // safe default
    endcase
  end

  // Outputs based on Moore FSM (only depend on current state)
  assign walk_left  = (state == WALK_LEFT) || (state == DIGGING_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIGGING_RIGHT);
  assign digging    = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);
  assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);

endmodule