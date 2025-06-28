module TopModule (
  input clk,
  input j,
  input k,
  output reg Q
);

  always @(posedge clk) begin
    if (j & ~k)
      Q <= 1;
    else if (~j & k)
      Q <= 0;
    else if (j & k)
      Q <= ~Q;
    // No change in Q if both J and K are 0
  end

endmodule