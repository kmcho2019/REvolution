module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

// Define the states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Define the state registers
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

always @* begin
  // Default next state
  next_state = state;

  // State transitions
  case(state)
    WALK_LEFT: begin
      if (!ground) begin
        next_state = FALLING;
      end else if (dig) begin
        next_state = DIGGING;
      end else if (bump_right) begin
        next_state = WALK_RIGHT;
      end
    end
    WALK_RIGHT: begin
      if (!ground) begin
        next_state = FALLING;
      end else if (dig) begin
        next_state = DIGGING;
      end else if (bump_left) begin
        next_state = WALK_LEFT;
      end
    end
    FALLING: begin
      if (ground) begin
        next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
      end
    end
    DIGGING: begin
      if (!ground) begin
        next_state = FALLING;
      end
    end
  endcase
end

// Define outputs based on state
always @* begin
  walk_left = (state == WALK_LEFT) ? 1 : 0;
  walk_right = (state == WALK_RIGHT) ? 1 : 0;
  aaah = (state == FALLING) ? 1 : 0;
  digging = (state == DIGGING) ? 1 : 0;
end

endmodule