module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_hi = in[15:8];  // Directly assign upper 8 bits of input to out_hi
    assign out_lo = in[7:0];   // Directly assign lower 8 bits of input to out_lo

endmodule