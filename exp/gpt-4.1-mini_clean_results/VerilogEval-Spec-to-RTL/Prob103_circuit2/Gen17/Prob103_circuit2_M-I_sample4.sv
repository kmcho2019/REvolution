module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Even parity using reduction XOR with inversion (~^)
    assign q = ~(a ^ b ^ c ^ d);

endmodule