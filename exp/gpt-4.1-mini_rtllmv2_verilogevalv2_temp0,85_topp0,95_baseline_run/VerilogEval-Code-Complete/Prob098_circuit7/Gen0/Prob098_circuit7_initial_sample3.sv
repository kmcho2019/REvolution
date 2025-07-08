module TopModule (
  input clk,
  input a,
  output reg q
);

  initial q = 0;

  always @(posedge clk) begin
    if (a == 0)
      q <= 1;
    else
      q <= ~q;
  end

endmodule