// TopModule implements a half adder directly
// This module adds two bits without a carry-in and produces a sum and carry-out.
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
  // Perform XOR operation for sum calculation
  assign sum = a ^ b;
  
  // Perform AND operation for carry-out calculation
  assign cout = a & b;
endmodule