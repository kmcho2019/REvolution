module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Directly assign the required bits to the output signals
    assign out_hi = in[15:8];  // Upper 8 bits
    assign out_lo = in[7:0];   // Lower 8 bits

endmodule