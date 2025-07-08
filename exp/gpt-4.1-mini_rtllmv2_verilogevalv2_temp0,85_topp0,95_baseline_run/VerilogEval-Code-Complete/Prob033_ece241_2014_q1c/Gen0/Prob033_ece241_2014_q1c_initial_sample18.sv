module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);
  wire [8:0] sum_ext;

  assign sum_ext = {a[7], a} + {b[7], b};  // sign extend inputs and add
  assign s = sum_ext[7:0];

  // Overflow occurs if sign of a and b are the same but sign of sum is different
  assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule