module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

  always @* begin
    out = ((~a & ~b & c) | (~a & b & c) | (a & b) | (a & ~b) | (a & b & ~c) | (a & ~b & ~c));
  end

endmodule