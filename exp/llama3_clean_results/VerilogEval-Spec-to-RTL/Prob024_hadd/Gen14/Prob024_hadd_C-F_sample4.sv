// Define an optimized module for XOR gate
module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a ^ b;
endmodule

// Define an optimized module for AND gate
module AND(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a & b;
endmodule

// TopModule instantiates optimized XOR and AND gates for half adder functionality
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Instantiate XOR and AND modules with minimized switching activity
XOR u_xor(a, b, sum);
AND u_and(a, b, cout);
endmodule