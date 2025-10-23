module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute parity of all four inputs directly using reduction XOR
    assign out = ^{a, b, c, d};
endmodule