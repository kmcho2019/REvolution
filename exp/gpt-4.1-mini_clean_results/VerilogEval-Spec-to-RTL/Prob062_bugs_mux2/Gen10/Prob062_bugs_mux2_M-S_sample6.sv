module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // 1-bit 2-to-1 mux selecting LSB of a or b
    assign out = sel ? b[0] : a[0];

endmodule