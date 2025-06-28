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
parameter IDLE = 2'b00;
parameter WALK_LEFT = 2'b01;
parameter WALK_RIGHT = 2'b10;
parameter FALLING = 2'b11;

// Define state register
reg [1:0] state, next_state;

// Moore state machine logic
always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT; // Reset state
  end else begin
    state <= next_state; // Update state
  end
end

// Next state logic based on inputs and current state
always @* begin
  next_state = state;
  aaah = 0;
  digging = 0;

  case (state)
    IDLE: begin
      walk_left = 0;
      walk_right = 0;
      if (ground && !falling) begin
        if (bump_left) next_state = WALK_RIGHT;
        else if (bump_right) next_state = WALK_LEFT;
        else if (dig) next_state = DIGGING;
      end
    end

    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      if (bump_right) next_state = WALK_RIGHT;
      else if (!ground) next_state = FALLING;
      else if (dig) next_state = DIGGING;
    end

    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      if (bump_left) next_state = WALK_LEFT;
      else if (!ground) next_state = FALLING;
      else if (dig) next_state = DIGGING;
    end

    FALLING: begin
      walk_left = (state == WALK_LEFT);
      walk_right = (state == WALK_RIGHT);
      aaah = 1;
      if (ground) begin
        if (bump_left) next_state = WALK_RIGHT;
        else if (bump_right) next_state = WALK_LEFT;
        else next_state = walk_left ? WALK_LEFT : WALK_RIGHT;
      end
    end

    DIGGING: begin
      walk_left = (state == WALK_LEFT);
      walk_right = (state == WALK_RIGHT);
      digging = 1;
      if (!ground) next_state = FALLING;
    end
  endcase
end

endmodule