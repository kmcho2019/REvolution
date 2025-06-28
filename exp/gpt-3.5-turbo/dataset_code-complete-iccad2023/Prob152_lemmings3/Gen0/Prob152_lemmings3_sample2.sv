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

// Define states
parameter WALKING_LEFT = 2'b00;
parameter WALKING_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state, next_state;

// Moore state machine logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALKING_LEFT;
  end else begin
    state <= next_state;
  end
end

// Output logic
always @* begin
  walk_left = (state == WALKING_LEFT);
  walk_right = (state == WALKING_RIGHT);
  aaah = (state == FALLING);
  digging = (state == DIGGING);
end

// State transition and output assignment logic
always @* begin
  next_state = state;
  aaah = 0;
  digging = 0;

  case (state)
    WALKING_LEFT:
      if (ground) begin
        if (bump_right) next_state = WALKING_RIGHT;
        else if (dig) next_state = DIGGING;
      end else begin
        next_state = FALLING;
        aaah = 1;
      end
    WALKING_RIGHT:
      if (ground) begin
        if (bump_left) next_state = WALKING_LEFT;
        else if (dig) next_state = DIGGING;
      end else begin
        next_state = FALLING;
        aaah = 1;
      end
    FALLING:
      if (ground) begin
        if (state == WALKING_LEFT) next_state = WALKING_LEFT;
        else next_state = WALKING_RIGHT;
      end
    DIGGING:
      if (!ground) begin
        next_state = FALLING;
        aaah = 1;
      end
  endcase
end

endmodule