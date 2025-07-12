module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection - most efficient implementation
    assign out = in[sel];

endmodule