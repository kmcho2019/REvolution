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
localparam WALK_LEFT     = 3'd0;
localparam WALK_RIGHT    = 3'd1;
localparam FALLING_LEFT  = 3'd2;
localparam FALLING_RIGHT = 3'd3;
localparam DIGGING_LEFT  = 3'd4;
localparam DIGGING_RIGHT = 3'd5;

reg [2:0] state, next_state;

// State transitions
always @(*) begin
  case(state)
    // Walking left
    WALK_LEFT: begin
      if (ground == 0) begin
        // fall overrides all
        next_state = FALLING_LEFT;
      end else if (dig == 1) begin
        next_state = DIGGING_LEFT;
      end else if (bump_left == 1 || bump_right == 1) begin
        // switch directions if bumped on left or right (or both)
        next_state = WALK_RIGHT;
      end else begin
        next_state = WALK_LEFT;
      end
    end

    // Walking right
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

    // Falling left
    FALLING_LEFT: begin
      if (ground == 1) begin
        // stop falling, resume walking left
        next_state = WALK_LEFT;
      end else begin
        next_state = FALLING_LEFT;
      end
    end

    // Falling right
    FALLING_RIGHT: begin
      if (ground == 1) begin
        next_state = WALK_RIGHT;
      end else begin
        next_state = FALLING_RIGHT;
      end
    end

    // Digging left
    DIGGING_LEFT: begin
      if (ground == 0) begin
        // fall when ground disappears during digging
        next_state = FALLING_LEFT;
      end else begin
        next_state = DIGGING_LEFT;
      end
    end

    // Digging right
    DIGGING_RIGHT: begin
      if (ground == 0) begin
        next_state = FALLING_RIGHT;
      end else begin
        next_state = DIGGING_RIGHT;
      end
    end

    default: next_state = WALK_LEFT;
  endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

// Output logic - Moore outputs depend only on state
assign walk_left  = (state == WALK_LEFT) || (state == FALLING_LEFT) || (state == DIGGING_LEFT);
assign walk_right = (state == WALK_RIGHT) || (state == FALLING_RIGHT) || (state == DIGGING_RIGHT);
assign aaah       = (state == FALLING_LEFT) || (state == FALLING_RIGHT);
assign digging    = (state == DIGGING_LEFT) || (state == DIGGING_RIGHT);

endmodule