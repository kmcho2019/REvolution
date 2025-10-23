module TopModule(clk, w, R, E, L, Q);
  input clk, w, R, E, L;
  output Q;
  reg Q;

  always @(posedge clk)
    if (L)
      Q <= R;
    else if (E)
      Q <= w;
    else
      Q <= Q;

endmodule