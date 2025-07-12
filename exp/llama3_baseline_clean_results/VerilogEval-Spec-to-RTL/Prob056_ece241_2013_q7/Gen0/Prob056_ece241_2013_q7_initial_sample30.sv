module TopModule(clk, j, k, Q);
  input clk, j, k;
  output Q;
  reg Q;

  always @(posedge clk)
    if (j == 0 && k == 0) Q <= Q;
    else if (j == 0 && k == 1) Q <= 0;
    else if (j == 1 && k == 0) Q <= 1;
    else if (j == 1 && k == 1) Q <= ~Q;

endmodule