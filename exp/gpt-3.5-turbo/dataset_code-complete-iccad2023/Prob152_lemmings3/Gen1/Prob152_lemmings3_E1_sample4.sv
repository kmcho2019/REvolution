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

// State definition
parameter WALKING = 2'b00, FALLING = 2'b01, DIGGING = 2'b10;
reg [1:0] state, next_state;

// Moore outputs
always @(state) begin
  case(state)
    WALKING: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      digging = 0;
    end
    FALLING: begin
      walk_left = (state == WALKING);
      walk_right = (state != WALKING);
      aaah = 1;
      digging = 0;
    end
    DIGGING: begin
      walk_left = (state == WALKING);
      walk_right = (state != WALKING);
      aaah = 0;
      digging = 1;
    end
  endcase
end

// State transitions
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALKING;
  end else begin
    state <= next_state;
  end
end

// Next state logic
always @(*) begin
  next_state = state; // Default next state

  case(state)
    WALKING: begin
      if (!ground) next_state = FALLING;
      else if (dig) next_state = DIGGING;
      else if (bump_left) next_state = WALKING;
      else if (bump_right) next_state = WALKING;
    end

    FALLING: begin
      if (ground) next_state = (state == WALKING) ? WALKING : FALLING;
    end

    DIGGING: begin
      if (!ground) next_state = FALLING;
    end
  endcase
end

endmodule