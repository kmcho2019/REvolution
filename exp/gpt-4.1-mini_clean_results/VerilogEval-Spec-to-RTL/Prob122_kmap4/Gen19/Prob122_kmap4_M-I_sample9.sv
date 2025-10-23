module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Output is parity (XOR reduction) of all inputs
    assign out = ^{a, b, c, d};

endmodule