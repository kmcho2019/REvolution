module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct selection using the full 8-bit selector
    assign out = in[sel];

endmodule