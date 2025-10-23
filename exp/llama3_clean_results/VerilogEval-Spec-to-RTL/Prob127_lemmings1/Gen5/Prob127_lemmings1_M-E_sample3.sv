module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg [1:0] direction;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    direction <= 0;
  end else if (bump_left || bump_right) begin
    direction <= direction + 1;
  end
end

assign walk_left = (direction[1] == 0);
assign walk_right = (direction[1] == 1);

endmodule