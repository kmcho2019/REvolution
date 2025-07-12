module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute the parity of all four inputs directly using a reduction XOR
    assign out = ^{a, b, c, d};
endmodule