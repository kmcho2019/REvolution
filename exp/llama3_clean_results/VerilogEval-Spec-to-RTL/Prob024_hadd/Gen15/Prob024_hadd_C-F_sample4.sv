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

// Define a separate module for 2-to-1 multiplexer
// This module takes three inputs (a, b, and sel) and produces an output (out)
// The output is the result of the multiplexer operation based on the select signal
module MUX2TO1(
    input  logic a,
    input  logic b,
    input  logic sel,
    output logic out
);
assign out = (sel) ? b : a;
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

// Alternative implementation using multiplexer-based approach
module TopModule_MUX(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
logic and_result;

// Compute the carry-out (AND of a and b)
assign and_result = a & b;
assign cout = and_result;

// Use a multiplexer to compute the sum based on the carry-out condition
MUX2TO1 u_mux(a ^ b, 1'b0, and_result, sum);
endmodule