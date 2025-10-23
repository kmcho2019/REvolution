module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection - simplest possible implementation
    assign out = in[sel];

endmodule