module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Simplified parity: direct XOR of all inputs
    assign out = a ^ b ^ c ^ d;

endmodule