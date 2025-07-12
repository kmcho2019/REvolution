module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;
  
  always @(posedge clk)
    q <= ~a;
  
endmodule