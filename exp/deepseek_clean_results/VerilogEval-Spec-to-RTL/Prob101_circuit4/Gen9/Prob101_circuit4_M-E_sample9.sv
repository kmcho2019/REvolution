module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Priority-based decision tree
    // First check high-priority inputs (b or c)
    // Then handle remaining cases based on a and d
    assign q = (b | c) | (a & d);

endmodule