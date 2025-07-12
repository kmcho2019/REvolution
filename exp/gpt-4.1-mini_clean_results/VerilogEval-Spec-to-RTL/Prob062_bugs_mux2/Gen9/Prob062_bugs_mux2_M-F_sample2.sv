module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Output a single bit from a or b depending on sel
    assign out = sel ? b[0] : a[0];

endmodule