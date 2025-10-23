module TopModule(clk, a, q);
  input clk, a;
  output q;
  reg q;

  always @(posedge clk) begin
    if(a == 1'b0 && q == 1'b0)
      q <= 1'b1;
    else if(a == 1'b1 && q == 1'b1)
      q <= 1'b0;
  end

  initial q = 1'b0;
endmodule