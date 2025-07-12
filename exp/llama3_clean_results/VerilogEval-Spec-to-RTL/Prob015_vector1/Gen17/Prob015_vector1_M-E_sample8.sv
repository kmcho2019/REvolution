module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Direct bit manipulation for simplicity and efficiency
    assign out_hi = in[15:8];  // Extract upper 8 bits
    assign out_lo = in[7:0];   // Extract lower 8 bits

endmodule