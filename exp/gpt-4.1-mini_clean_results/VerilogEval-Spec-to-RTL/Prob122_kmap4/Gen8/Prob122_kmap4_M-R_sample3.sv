module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Use reduction XOR on concatenated inputs to directly produce output
    assign out = ^{a, b, c, d};
endmodule