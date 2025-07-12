module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // Single-bit 2-to-1 mux selecting bit 0 of inputs a and b
    assign out = (~sel & a[0]) | (sel & b[0]);

endmodule