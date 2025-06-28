module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// State definition
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;
reg state, next_state;

// Moore state machine
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

// State transition and output logic
always @* begin
  case(state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      if (bump_right)
        next_state = WALK_RIGHT;
      else if (bump_left)
        next_state = WALK_LEFT;
      else
        next_state = WALK_RIGHT; // switch direction if bumped on both sides
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      if (bump_left)
        next_state = WALK_LEFT;
      else if (bump_right)
        next_state = WALK_RIGHT;
      else
        next_state = WALK_LEFT; // switch direction if bumped on both sides
    end
  endcase
end

endmodule