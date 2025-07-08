module TopModule (
  input clk,
  input a,
  output reg q
);

  always @(posedge clk) begin
    if (q == 0 && a == 0)
      q <= 1;
    else if (q == 1 && a == 1)
      q <= 0;
    else
      q <= q;
  end

endmodule