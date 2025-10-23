module TopModule(input clk, input a, output reg q);
  reg a_d;
  always @(posedge clk) begin
    a_d <= a;
    if (a != a_d)
      q <= ~a;
  end
endmodule