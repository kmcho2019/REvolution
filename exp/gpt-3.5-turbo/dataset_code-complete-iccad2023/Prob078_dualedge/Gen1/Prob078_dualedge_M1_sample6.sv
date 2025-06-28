module TopModule (
  input clk,
  input d,
  output reg q
);

reg prev_d;
reg prev_d_neg;

always @(posedge clk) begin
  prev_d <= d;
  prev_d_neg <= ~d;
  q <= (prev_d & prev_d_neg) | (d & ~prev_d);
end

endmodule