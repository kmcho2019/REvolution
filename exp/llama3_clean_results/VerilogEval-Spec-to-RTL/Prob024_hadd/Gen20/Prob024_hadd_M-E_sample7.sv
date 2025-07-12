// TopModule implements a half adder using a single combinatorial logic circuit
// This module adds two bits without a carry-in and produces a sum and carry-out.
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
  // Calculate sum using XOR operation
  assign sum = a ^ b;
  
  // Calculate carry-out using AND operation
  assign cout = a & b;
endmodule