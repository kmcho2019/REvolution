module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg current_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= 0; // Reset to walking left
  end else begin
    if (bump_left && bump_right) begin
      current_state <= ~current_state; // Switch direction if bumped from both sides
    end else if (bump_left) begin
      current_state <= 1; // Walk right if bumped from left
    end else if (bump_right) begin
      current_state <= 0; // Walk left if bumped from right
    end else begin
      current_state <= current_state; // Stay in current direction if no bumps
    end
  end
end

assign walk_left = ~current_state;
assign walk_right = current_state;

endmodule