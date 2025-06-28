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
parameter FALL = 2'b10;
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
      if (bump_right) begin
        next_state = WALK_RIGHT;
      end else if (!ground) begin
        next_state = FALL;
      end else if (dig) begin
        next_state = DIGGING;
      end
    end
    WALK_RIGHT: begin
      if (bump_left) begin
        next_state = WALK_LEFT;
      end else if (!ground) begin
        next_state = FALL;
      end else if (dig) begin
        next_state = DIGGING;
      end
    end
    FALL: begin
      if (ground) begin
        next_state = state == WALK_LEFT ? WALK_RIGHT : WALK_LEFT;
      end
    end
    DIGGING: begin
      if ((!ground) || (dig && (state == WALK_LEFT))) begin
        next_state = FALL;
      end
    end
  endcase
end

// Define outputs based on state
always @* begin
  case(state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      digging = 0;
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      aaah = 0;
      digging = 0;
    end
    FALL: begin
      walk_left = state == WALK_LEFT ? 0 : 1;
      walk_right = state == WALK_LEFT ? 1 : 0;
      aaah = ground ? 0 : 1;
      digging = 0;
    end
    DIGGING: begin
      walk_left = 0;
      walk_right = 0;
      aaah = 0;
      digging = 1;
    end
  endcase
end

endmodule