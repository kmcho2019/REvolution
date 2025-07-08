module TopModule (
  input clk,
  input a,
  output reg q
);

  always @(posedge clk) begin
    if (a == 0 && q == 0)
      q <= 1;
    else if (a == 1 && q == 1)
      q <= 0;
    else
      q <= q;
  end

endmodule