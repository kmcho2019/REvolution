module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct selection using part-select with concatenated index
    assign out = in[sel];

endmodule