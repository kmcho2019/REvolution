module TopModule(clk, j, k, Q);
  input clk, j, k;
  output Q;
  reg Q;

  always @(posedge clk)
    if (~j & ~k) Q <= Q; // Q remains the same
    else if (~j & k) Q <= 1'b0; // Q is reset
    else if (j & ~k) Q <= 1'b1; // Q is set
    else Q <= ~Q; // Q is toggled

endmodule