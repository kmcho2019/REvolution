module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Directly assign upper and lower 8 bits to outputs
    assign out_lo = in[7:0];
    assign out_hi = in[15:8];

endmodule