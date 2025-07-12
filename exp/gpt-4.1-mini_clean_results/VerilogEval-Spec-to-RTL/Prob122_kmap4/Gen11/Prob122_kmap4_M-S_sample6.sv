module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output is parity of all four inputs using a single reduction XOR
    assign out = ^{a, b, c, d};
endmodule