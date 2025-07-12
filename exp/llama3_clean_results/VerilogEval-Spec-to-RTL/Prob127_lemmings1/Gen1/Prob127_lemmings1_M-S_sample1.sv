module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

parameter WALK_LEFT = 0, WALK_RIGHT = 1;
reg state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else if (bump_left || bump_right) begin
    state <= ~state;
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