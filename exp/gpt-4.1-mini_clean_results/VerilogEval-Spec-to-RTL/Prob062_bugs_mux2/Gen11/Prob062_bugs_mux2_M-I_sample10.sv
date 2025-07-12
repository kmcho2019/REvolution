module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    // 1-bit 2-to-1 mux selecting the LSB of inputs a or b based on sel
    assign out = sel ? b[0] : a[0];

endmodule