module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  initial q = 0;

  always @(posedge clk) begin
    if(a == 0 && q == 0) begin
      q <= 1;
    end else if(a == 1) begin
      q <= 0;
    end
  end
endmodule