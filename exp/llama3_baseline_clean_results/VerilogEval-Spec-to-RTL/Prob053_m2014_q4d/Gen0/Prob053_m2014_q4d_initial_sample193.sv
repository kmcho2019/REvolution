module TopModule(clk, in, out);
  input clk;
  input in;
  output out;
  reg out;

  always @(posedge clk)
    out <= in ^ out;
endmodule