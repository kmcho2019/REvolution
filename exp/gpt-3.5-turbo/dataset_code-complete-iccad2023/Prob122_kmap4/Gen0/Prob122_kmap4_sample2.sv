module TopModule (
  input a,
  input b,
  input c,
  input d,
  output reg out
);

// XOR operation between a, b, c, and d
assign out = a ^ b ^ c ^ d;

endmodule