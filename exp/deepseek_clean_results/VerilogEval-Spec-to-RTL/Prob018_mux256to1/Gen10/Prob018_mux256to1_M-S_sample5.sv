module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection using sel as index
    assign out = in[sel];

endmodule