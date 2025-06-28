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
  if (pattern == PATTERN_DETECT)
    state <= 1'b1;
  else
    state <= 1'b0;

  case (pattern)
    3'b000: pattern <= {pattern[1:0], a};
    default: pattern <= {pattern[1:0], a};
  endcase
end

always @(posedge clk) begin
  q <= (state == 1'b1) ? 1'b1 : 1'b0;
end

endmodule