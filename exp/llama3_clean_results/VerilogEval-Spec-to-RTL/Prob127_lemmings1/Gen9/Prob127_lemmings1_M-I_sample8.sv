module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg direction;

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    direction <= 1'b0; // initialize direction to left (0)
  end else begin
    if (bump_left && ~bump_right) begin
      direction <= 1'b1; // change direction to right (1)
    end else if (~bump_left && bump_right) begin
      direction <= 1'b0; // change direction to left (0)
    end else if (bump_left && bump_right) begin
      direction <= ~direction; // toggle direction
    end
  end
end

// Use assign statements for combinational logic
assign walk_left = ~direction;
assign walk_right = direction;

endmodule