module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg walk_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    walk_state <= 0;
  end else if (bump_left && bump_right) begin
    walk_state <= ~walk_state;
  end else if (bump_left) begin
    walk_state <= 1;
  end else if (bump_right) begin
    walk_state <= 0;
  end
end

always @(*) begin
  walk_left = ~walk_state;
  walk_right = walk_state;
end

endmodule