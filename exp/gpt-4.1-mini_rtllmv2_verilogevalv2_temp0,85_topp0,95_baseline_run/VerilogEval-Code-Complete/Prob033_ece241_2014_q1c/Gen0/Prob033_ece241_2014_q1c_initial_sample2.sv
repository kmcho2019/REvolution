module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output overflow
);
  wire [8:0] sum_ext;
  
  // Extend inputs to 9 bits for addition to capture carry out
  assign sum_ext = {a[7], a} + {b[7], b};
  assign s = sum_ext[7:0];
  
  // Overflow detection:
  // Overflow occurs when the carry into the MSB differs from carry out of MSB,
  // or equivalently, when a and b have the same sign but s has a different sign.
  assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule