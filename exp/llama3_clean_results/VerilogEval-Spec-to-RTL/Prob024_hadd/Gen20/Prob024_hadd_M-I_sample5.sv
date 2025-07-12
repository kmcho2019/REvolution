// Define a module for the half adder
// This module implements a half adder, which adds two bits without a carry-in.
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
  // Perform sum calculation using XOR operation
  assign sum = a ^ b;
  
  // Perform carry-out calculation using AND operation
  assign cout = a & b;
endmodule