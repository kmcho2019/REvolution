// Define an optimized module for XOR gate
module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a ^ b; // XOR operation
endmodule

// Define an optimized module for AND gate
module AND(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a & b; // AND operation
endmodule

// TopModule instantiates optimized XOR and AND gates for half adder functionality
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Instantiate XOR and AND gates with minimized switching activity
XOR u_xor(a, b, sum);
AND u_and(a, b, cout);
endmodule

// Alternative implementation with direct logic operations
module TopModule_Optimized(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = a ^ b; // Direct XOR operation for sum
assign cout = a & b; // Direct AND operation for carry-out
endmodule