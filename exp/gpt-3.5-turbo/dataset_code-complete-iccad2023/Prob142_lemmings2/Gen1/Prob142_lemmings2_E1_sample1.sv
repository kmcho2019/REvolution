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
parameter FALLING = 2'b10;
parameter GROUND = 2'b11;

// State and output registers
reg [1:0] state, next_state;
reg aaah_out;

// Moore state transition and output logic
always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT; // Reset to initial state
  end
  else begin
    state <= next_state;
  end
end

always @* begin
  aaah_out = (ground == 0) ? 1 : 0;
  case (state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      aaah = aaah_out;
      next_state = (bump_right) ? WALK_LEFT :
                   (bump_left) ? WALK_RIGHT :
                   (ground == 0) ? FALLING : WALK_LEFT;
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      aaah = aaah_out;
      next_state = (bump_left) ? WALK_RIGHT :
                   (bump_right) ? WALK_LEFT :
                   (ground == 0) ? FALLING : WALK_RIGHT;
    end
    FALLING: begin
      walk_left = (state == WALK_LEFT) ? 1 : 0;
      walk_right = (state == WALK_RIGHT) ? 1 : 0;
      aaah = 1;
      next_state = (ground == 1) ? GROUND : FALLING;
    end
    GROUND: begin
      walk_left = (state == WALK_LEFT) ? 1 : 0;
      walk_right = (state == WALK_RIGHT) ? 1 : 0;
      aaah = 0;
      next_state = (bump_left) ? WALK_RIGHT :
                   (bump_right) ? WALK_LEFT :
                   (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
    end
  endcase
end

endmodule