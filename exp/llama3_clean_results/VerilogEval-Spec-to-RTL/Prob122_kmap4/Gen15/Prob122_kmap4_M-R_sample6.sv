module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out
);

    logic ab_xor, abc_xor;

    assign ab_xor = a ^ b;
    assign abc_xor = ab_xor ^ c;
    assign out = abc_xor ^ d;

endmodule