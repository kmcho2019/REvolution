// Define a separate module for XOR gate
// This module takes two inputs (a and b) and produces an output (out)
// The output is the result of the XOR operation between a and b
module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a ^ b; // XOR operation
endmodule

// Define a separate module for AND gate
// This module takes two inputs (a and b) and produces an output (out)
// The output is the result of the AND operation between a and b
module AND(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a & b; // AND operation
endmodule

// TopModule instantiates XOR and AND gates for half adder functionality
// It takes two inputs (a and b), and produces two outputs (sum and cout)
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Instantiate XOR gate for sum calculation
XOR u_xor(a, b, sum);
// Instantiate AND gate for carry-out calculation
AND u_and(a, b, cout);
endmodule