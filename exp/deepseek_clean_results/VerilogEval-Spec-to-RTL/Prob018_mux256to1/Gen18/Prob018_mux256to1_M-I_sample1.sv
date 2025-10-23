module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct bit selection from 256-bit input
    assign out = in[sel];

endmodule