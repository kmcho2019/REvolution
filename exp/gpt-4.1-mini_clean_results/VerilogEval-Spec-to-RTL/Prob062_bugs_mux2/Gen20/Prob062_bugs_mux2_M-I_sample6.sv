module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Scalar output selects bit 0 of a or b based on sel
    assign out = sel ? b[0] : a[0];

endmodule