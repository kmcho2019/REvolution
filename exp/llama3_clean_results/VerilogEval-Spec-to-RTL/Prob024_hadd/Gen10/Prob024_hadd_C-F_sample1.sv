module XOR(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a ^ b;
endmodule

module AND(
    input  logic a,
    input  logic b,
    output logic out
);
assign out = a & b;
endmodule

module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Using bitwise operations within the XOR and AND modules
// would not provide any additional benefits in this case,
// as the operations are already optimized.
XOR u_xor(a, b, sum);
AND u_and(a, b, cout);
endmodule