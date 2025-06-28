module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [2:0] pattern;
parameter PATTERN_DETECT = 3'b010;

always @(posedge clk) begin
  pattern <= {pattern[1:0], a};
  state <= (pattern == PATTERN_DETECT) ? 1'b1 : 1'b0;
  q <= (state == 1'b1) ? 1'b1 : 1'b0;
end

endmodule