module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg state; // Using a single-bit state variable

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 0; // Initialize state to LEFT (0)
  end else begin
    state <= (bump_left && !state) || (bump_right && state) ? !state : state;
  end
end

// Use assign statements for combinational logic
assign walk_left = !state; // LEFT state
assign walk_right = state; // RIGHT state

endmodule