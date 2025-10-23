module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create 100-bit masks based on select signal
    wire [99:0] a_mask = {100{~sel}};
    wire [99:0] b_mask = {100{sel}};

    // Apply masks and combine results
    assign out = (a & a_mask) | (b & b_mask);

    /* Implementation Notes:
     * 1. The mask generation creates either all 1's or all 0's based on sel
     * 2. Each bit is processed independently and in parallel
     * 3. The final OR operation combines the selected bits
     * 
     * Potential Optimizations:
     * - Synthesis tools will typically optimize this to the same structure as ternary
     * - May offer better power characteristics in some technologies
     * - Explicit parallelism can help with physical design placement
     */
endmodule