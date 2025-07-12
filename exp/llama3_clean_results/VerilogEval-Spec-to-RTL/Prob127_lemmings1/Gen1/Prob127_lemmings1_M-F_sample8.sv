module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

parameter WALK_LEFT = 0, WALK_RIGHT = 1;
reg [0:0] state;
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  if (bump_left && bump_right) begin
    next_state <= (state == WALK_LEFT)? WALK_RIGHT : WALK_LEFT;
  end else if (bump_left) begin
    next_state <= WALK_RIGHT;
  end else if (bump_right) begin
    next_state <= WALK_LEFT;
  end else begin
    next_state <= state;
  end
end

always @(*) begin
  case (state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
    end
  endcase
end

endmodule