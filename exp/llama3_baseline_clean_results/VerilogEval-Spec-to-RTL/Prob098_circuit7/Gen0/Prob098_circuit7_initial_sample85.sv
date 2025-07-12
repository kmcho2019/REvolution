module TopModule(clk, a, q);
  input clk;
  input a;
  output q;
  reg q;

  always @(posedge clk) begin
    if (a) begin
      q <= ~q;
    end
  end
endmodule