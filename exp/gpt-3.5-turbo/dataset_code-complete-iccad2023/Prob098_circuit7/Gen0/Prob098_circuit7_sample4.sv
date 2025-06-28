module TopModule (
  input clk,
  input a,
  output reg q
);

  always @ (posedge clk or posedge a)
    if (a)
      q <= 1'b0;
    else
      q <= a;

endmodule