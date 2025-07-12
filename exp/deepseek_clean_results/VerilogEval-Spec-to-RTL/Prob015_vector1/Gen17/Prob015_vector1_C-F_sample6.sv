module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Single assignment with clear byte separation
    assign {out_hi[7:0], out_lo[7:0]} = in[15:0];

endmodule