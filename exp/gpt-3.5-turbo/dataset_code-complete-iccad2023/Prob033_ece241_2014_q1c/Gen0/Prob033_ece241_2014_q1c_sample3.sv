module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);

  wire [7:0] sum;
  wire Cout;

  assign {Cout, s} = a + b;
  assign overflow = Cout ^ (s[7] ^ a[7] ^ b[7]);

endmodule