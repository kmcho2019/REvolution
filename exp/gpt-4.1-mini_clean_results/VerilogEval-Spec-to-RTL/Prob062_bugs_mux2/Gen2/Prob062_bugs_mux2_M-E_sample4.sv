module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Select input vector based on sel, then reduce OR all bits to produce single-bit output
    assign out = |(sel ? b : a);

endmodule