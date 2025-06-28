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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL_THEN_WALK = 2'b10;
parameter FALLING = 2'b11;

// Define state and next state registers
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset) state <= WALK_LEFT;
  else state <= next_state;
end

always @* begin
  next_state = state;
  walk_left = 0;
  walk_right = 0;
  aaah = 0;
  digging = 0;

  case(state)
    WALK_LEFT: begin
      if (bump_right) next_state = WALK_RIGHT;
      else if (!ground) next_state = FALLING;
      else if (dig) next_state = FALLING; // Digging transitions to FALLING
      else walk_left = 1;
    end

    WALK_RIGHT: begin
      if (bump_left) next_state = WALK_LEFT;
      else if (!ground) next_state = FALLING;
      else if (dig) next_state = FALLING; // Digging transitions to FALLING
      else walk_right = 1;
    end

    FALL_THEN_WALK: begin
      if (ground) next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
    end

    FALLING: begin
      aaah = 1;
      if (ground) next_state = FALL_THEN_WALK;
      else if (!dig) next_state = FALLING; // Only set to FALLING if not digging
    end
  endcase
end

endmodule