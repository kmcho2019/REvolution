module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg [0:0] counter; // 1-bit counter

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    counter <= 0; // Initialize counter to 0
    walk_left <= 1; // Initialize walk_left to 1
    walk_right <= 0; // Initialize walk_right to 0
  end else begin
    if (bump_left && !bump_right) begin
      counter <= ~counter; // Toggle counter if bumped left
    end else if (bump_right && !bump_left) begin
      counter <= ~counter; // Toggle counter if bumped right
    end else if (bump_left && bump_right) begin
      counter <= ~counter; // Toggle counter if bumped both sides
    end
    walk_left <= ~counter; // Update walk_left based on counter
    walk_right <= counter; // Update walk_right based on counter
  end
end

endmodule