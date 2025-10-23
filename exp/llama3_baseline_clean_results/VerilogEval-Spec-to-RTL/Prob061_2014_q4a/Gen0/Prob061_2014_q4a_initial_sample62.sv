module TopModule(clk, w, R, E, L, Q);
  input clk;
  input w;
  input R;
  input E;
  input L;
  output Q;
  reg Q;

  always @(posedge clk) begin
    if (L)
      Q <= R;
    else if (E)
      Q <= w;
  end
endmodule