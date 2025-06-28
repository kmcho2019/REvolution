module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

// Define states
typedef enum logic [1:0] {
  WALK_LEFT,
  WALK_RIGHT,
  FALLING
} state_type;

// State register
reg [1:0] state, next_state;

// Output logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

// State transition and output logic
always @* begin
  aaah = 0;
  walk_left = (state == WALK_LEFT);
  walk_right = (state == WALK_RIGHT);
  
  case(state)
    WALK_LEFT: begin
      if (bump_right) begin
        next_state = WALK_RIGHT;
      end else if (ground) begin
        next_state = WALK_LEFT;
      end else begin
        next_state = state;
      end
    end
    WALK_RIGHT: begin
      if (bump_left) begin
        next_state = WALK_LEFT;
      end else if (ground) begin
        next_state = WALK_RIGHT;
      end else begin
        next_state = state;
      end
    end
    FALLING: begin
      aaah = 1;
      if (ground) begin
        next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
      end else begin
        next_state = FALLING;
      end
    end
  endcase
end

endmodule