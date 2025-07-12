module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Directly select the bit specified by sel
    assign out = in[sel];

endmodule