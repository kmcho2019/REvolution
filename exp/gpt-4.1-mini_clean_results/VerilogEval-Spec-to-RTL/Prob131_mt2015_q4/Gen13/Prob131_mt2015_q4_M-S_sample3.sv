module TopModule(input wire x, input wire y, output wire z);
  // Original:
  // A = (x ^ y) & x
  // B = ~(x ^ y)
  // z = ((A | B) ^ (A & B))
  //
  // Let a = A, b = B
  // z = (a | b) ^ (a & b) = (a XOR b)
  //
  // Substitute:
  // a = (x ^ y) & x
  // b = ~(x ^ y)
  //
  // Therefore:
  // z = a XOR b = ((x ^ y) & x) XOR ~(x ^ y)

  wire xy_xor = x ^ y;
  wire a = xy_xor & x;
  wire b = ~xy_xor;
  assign z = a ^ b;
endmodule