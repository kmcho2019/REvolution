module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Output is XOR (parity) of inputs a, b, c, d
    assign out = a ^ b ^ c ^ d;

endmodule