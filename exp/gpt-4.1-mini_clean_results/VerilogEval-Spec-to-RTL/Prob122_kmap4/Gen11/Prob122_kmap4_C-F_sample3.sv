module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output wire out
);

    // Output is XOR parity of all four inputs, matching the Karnaugh map pattern.
    // Using reduction XOR operator on concatenated inputs for minimal logic area and power.
    assign out = ^{a, b, c, d};

endmodule