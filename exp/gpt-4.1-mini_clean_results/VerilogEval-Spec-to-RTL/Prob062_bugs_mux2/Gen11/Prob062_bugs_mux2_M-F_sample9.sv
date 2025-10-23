module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Single-bit 2-to-1 mux selecting bit 0 of a or b
    assign out = sel ? b[0] : a[0];

endmodule