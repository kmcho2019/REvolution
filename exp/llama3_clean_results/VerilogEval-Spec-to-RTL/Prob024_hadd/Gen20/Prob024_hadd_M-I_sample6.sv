// Define an optimized module for XOR gate with reduced switching activity
module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = ~(a & b) & (a | b); // XOR operation with reduced switching activity
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

// Alternative implementation with direct logic operations and reduced switching activity
module TopModule_Optimized(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
assign sum = ~(a & b) & (a | b); // Direct XOR operation for sum with reduced switching activity
assign cout = a & b; // Direct AND operation for carry-out
endmodule