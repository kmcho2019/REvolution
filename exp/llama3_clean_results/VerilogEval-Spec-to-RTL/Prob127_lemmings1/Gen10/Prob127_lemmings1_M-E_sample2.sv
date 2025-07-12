module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg direction;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    direction <= 0; // Initialize direction to left
  end else begin
    if (bump_left || bump_right) begin
      direction <= ~direction; // Toggle direction on bump
    end
  end
end

assign walk_left = ~direction; // walk_left is high when direction is 0
assign walk_right = direction; // walk_right is high when direction is 1

endmodule