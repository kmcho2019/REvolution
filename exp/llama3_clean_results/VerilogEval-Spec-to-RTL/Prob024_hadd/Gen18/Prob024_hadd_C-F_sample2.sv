// Define an optimized module for XOR gate
// This module performs the XOR operation between two input bits.
module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
  // Perform XOR operation using bitwise XOR operator (^)
  assign out = a ^ b;
endmodule

// Define an optimized module for AND gate
// This module performs the AND operation between two input bits.
module AND(
    input  logic a,
    input  logic b,
    output logic out
);
  // Perform AND operation using bitwise AND operator (&)
  assign out = a & b;
endmodule

// TopModule instantiates optimized XOR and AND gates for half adder functionality
// This module implements a half adder, which adds two bits without a carry-in.
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
  // Instantiate XOR module for sum calculation
  XOR u_xor(a, b, sum);
  
  // Instantiate AND module for carry-out calculation
  AND u_and(a, b, cout);
endmodule