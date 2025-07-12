module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate enable signals
    wire enable_a = ~sel;
    wire enable_b = sel;
    
    // Instantiate 10 slices of 10-bit muxes
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice
            // Each slice handles 10 bits
            assign out[i*10 +: 10] = (enable_b ? b[i*10 +: 10] : a[i*10 +: 10]);
        end
    endgenerate

endmodule