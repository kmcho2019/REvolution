module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create 100-bit masks based on select signal
    wire [99:0] mask_a = {100{~sel}};
    wire [99:0] mask_b = {100{sel}};

    // Apply masks to inputs and combine results
    assign out = (a & mask_a) | (b & mask_b);

    /* Architectural Advantages:
     * 1. Explicit parallel processing of all bits
     * 2. May map better to certain FPGA architectures with efficient AND/OR LUTs
     * 3. Provides clear separation of data paths for synthesis optimization
     * 4. Potential for better power gating in some technologies
     * 
     * Implementation Notes:
     * - The mask generation is constant propagation friendly
     * - The AND-OR structure may be optimized into specialized cells in some libraries
     * - Maintains the same functionality as traditional mux implementation
     */
endmodule