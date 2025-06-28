module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @(*) begin
    out = (c == 0 && a == 0) || (b == 1 && a == 1);
  end

endmodule