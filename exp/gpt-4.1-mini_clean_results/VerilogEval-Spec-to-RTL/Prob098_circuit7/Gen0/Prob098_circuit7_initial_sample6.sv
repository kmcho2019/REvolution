module TopModule(
  input clk,
  input a,
  output reg q
);
  reg prev_a;
  always @(posedge clk) begin
    if (a & prev_a)
      q <= 0;
    else
      q <= 1;
    prev_a <= a;
  end
endmodule