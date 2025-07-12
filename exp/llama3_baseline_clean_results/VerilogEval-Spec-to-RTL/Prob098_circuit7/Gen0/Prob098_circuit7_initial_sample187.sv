module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  always @(posedge clk) begin
    q <= a ? ~q : q;
  end
endmodule