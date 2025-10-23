module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create local 4-bit selection masks for each group
    wire [3:0] sel_mask = {4{sel}};
    
    // Implement 25 parallel 4-bit muxes using bitwise operations
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux4bit
            assign out[i*4 +: 4] = (a[i*4 +: 4] & ~sel_mask) | (b[i*4 +: 4] & sel_mask);
        end
    endgenerate

    /* Key Advantages:
     * 1. Parallel processing maintains good timing characteristics
     * 2. Bitwise operations are synthesis-friendly
     * 3. No redundant select signal distribution logic
     * 4. Clear separation of control (sel_mask) and data paths
     * 5. Easily extensible to different bus widths
     * 6. Minimal power consumption with only essential logic
     */
endmodule