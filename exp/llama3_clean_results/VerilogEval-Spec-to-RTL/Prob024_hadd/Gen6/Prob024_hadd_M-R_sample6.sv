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
XOR u_xor(a, b, sum);
AND u_and(a, b, cout);
endmodule