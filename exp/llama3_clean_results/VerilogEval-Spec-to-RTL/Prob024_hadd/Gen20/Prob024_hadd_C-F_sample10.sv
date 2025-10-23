// Define a module for a half adder
// This module takes two inputs (a and b) and produces two outputs (sum and cout)
// The sum is the result of the XOR operation between a and b
// The cout is the result of the AND operation between a and b
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Directly implement the XOR operation for sum calculation
assign sum = a ^ b;
// Directly implement the AND operation for carry-out calculation
assign cout = a & b;
endmodule