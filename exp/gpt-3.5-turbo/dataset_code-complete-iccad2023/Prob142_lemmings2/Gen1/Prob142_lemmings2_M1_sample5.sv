module TopModule (
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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;

// State register
reg [1:0] state, next_state;

// State transition and output logic
always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT; // Reset to initial state
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  case (state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      next_state = (bump_right && !ground) ? WALK_LEFT :
                   (bump_left && !ground) ? WALK_RIGHT :
                   (ground && aaah) ? WALK_RIGHT : WALK_LEFT;
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      aaah = 0;
      next_state = (bump_left && !ground) ? WALK_RIGHT :
                   (bump_right && !ground) ? WALK_LEFT :
                   (ground && aaah) ? WALK_LEFT : WALK_RIGHT;
    end
  endcase
end

always @* begin
  if (ground == 0 && !aaah) begin
    aaah = 1;
  end
  else if (ground == 1) begin
    aaah = 0;
  end
end

endmodule