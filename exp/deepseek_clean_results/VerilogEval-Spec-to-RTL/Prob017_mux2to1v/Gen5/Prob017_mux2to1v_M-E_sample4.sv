module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Hierarchical 2-level mux structure
    // Level 1: 10 slices of 10-bit muxes
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : slice_mux
            // Each slice handles 10 bits
            assign out[i*10 +: 10] = sel ? b[i*10 +: 10] : a[i*10 +: 10];
        end
    endgenerate

    // Optional: Add clock gating control if this is in a clocked domain
    // (not shown in interface, but would be implemented here if needed)

endmodule