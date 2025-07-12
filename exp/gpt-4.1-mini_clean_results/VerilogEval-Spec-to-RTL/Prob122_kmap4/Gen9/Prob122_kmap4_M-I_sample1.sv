module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Use a single reduction XOR operator to express the output
    assign out = ^{a, b, c, d};
endmodule