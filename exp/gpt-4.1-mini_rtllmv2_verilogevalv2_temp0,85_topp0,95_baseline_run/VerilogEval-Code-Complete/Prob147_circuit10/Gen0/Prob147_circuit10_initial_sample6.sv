module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

  assign state = q;

  always @(posedge clk) begin
    if (a == 0 && b == 1)
      q <= 1'b1;
    else if (a == 1 && b == 1)
      q <= 1'b0;
    else if (a == 0 && b == 0)
      q <= ~q;
    else // a == 1 && b == 0
      q <= q;
  end

endmodule