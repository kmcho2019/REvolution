module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Generate 25 4-bit mux slices with individual enable signals
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux_slices
            // Enable signal for this slice (could be externally controlled)
            wire slice_enable = |(a[i*4 +:4] ^ b[i*4 +:4]); // Enable when inputs differ
            
            // 4-bit mux implementation
            assign out[i*4 +:4] = slice_enable ? (sel ? b[i*4 +:4] : a[i*4 +:4]) : a[i*4 +:4];
        end
    endgenerate

endmodule