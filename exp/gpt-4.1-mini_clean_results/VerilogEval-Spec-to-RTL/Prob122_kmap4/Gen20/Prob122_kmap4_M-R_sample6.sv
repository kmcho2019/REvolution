module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct XOR assignment for parity: out = a ^ b ^ c ^ d
    assign out = a ^ b ^ c ^ d;

endmodule