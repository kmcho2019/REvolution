module TopModule(clk, j, k, Q);
  input clk, j, k;
  output Q;
  reg Q;

  always @ (posedge clk)
    begin
      if (j == 0 && k == 0)
        Q <= Q;  // Q remains the same
      else if (j == 0 && k == 1)
        Q <= 0;  // Q is reset
      else if (j == 1 && k == 0)
        Q <= 1;  // Q is set
      else if (j == 1 && k == 1)
        Q <= ~Q;  // Q is toggled
    end
endmodule