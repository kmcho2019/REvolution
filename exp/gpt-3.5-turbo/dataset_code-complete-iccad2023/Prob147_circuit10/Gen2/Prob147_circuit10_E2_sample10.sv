module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [2:0] pattern;

always @(posedge clk) begin
  pattern <= {pattern[1:0], a};

  if (pattern == 3'b010)
    state <= 1'b1;
  else
    state <= 1'b0;

  q <= state;
end

endmodule