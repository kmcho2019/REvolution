module TopModule (
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    output logic sum,  // Sum of a and b
    output logic cout  // Carry-out from the addition of a and b
);

// Calculate the sum using XOR operation (a XOR b)
// This operation follows the binary addition rule where:
// - 0 + 0 = 0
// - 0 + 1 = 1
// - 1 + 0 = 1
// - 1 + 1 = 10 (where 0 is the sum and 1 is the carry)
assign sum = a ^ b;

// Calculate the carry-out using AND operation (a AND b)
// This operation follows the binary addition rule where a carry occurs only when both input bits are 1
assign cout = a & b;

endmodule