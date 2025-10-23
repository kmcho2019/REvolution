module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Directly compute parity of all four inputs using reduction XOR
    assign out = ^{a, b, c, d};

endmodule