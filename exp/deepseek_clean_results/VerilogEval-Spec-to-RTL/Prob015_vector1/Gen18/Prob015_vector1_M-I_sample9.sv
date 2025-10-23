module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,  // Explicitly matches in[15:8]
    output [7:0] out_lo   // Explicitly matches in[7:0]
);

    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule