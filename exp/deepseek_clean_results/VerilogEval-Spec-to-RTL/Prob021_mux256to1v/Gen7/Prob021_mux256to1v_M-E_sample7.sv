module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Implement 4 parallel 256-to-1 muxes (one for each output bit)
    assign out[0] = in[sel * 4 + 0];
    assign out[1] = in[sel * 4 + 1];
    assign out[2] = in[sel * 4 + 2];
    assign out[3] = in[sel * 4 + 3];

endmodule