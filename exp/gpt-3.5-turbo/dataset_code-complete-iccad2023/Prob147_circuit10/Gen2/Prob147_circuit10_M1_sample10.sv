module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [2:0] pattern;

always @(posedge clk) begin
  pattern <= {pattern[1:0], a}; // Shift in 'a' input to the pattern register
  state <= (pattern == 3'b010) ? 1'b1 : 1'b0; // Set state to '1' if pattern is detected, '0' otherwise
  q <= state; // Output 'q' follows the state
end

endmodule