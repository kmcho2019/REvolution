module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create a 100-bit mask where all bits equal sel
    wire [99:0] sel_mask = {100{sel}};
    
    // Select bits using the mask: when sel=0, mask is all 0s (select a)
    // when sel=1, mask is all 1s (select b)
    assign out = (a & ~sel_mask) | (b & sel_mask);

    /* Advantages:
     * 1. Potentially better power efficiency when sel is stable
     * 2. Clear separation of control (sel_mask) and data paths
     * 3. Uses only basic bitwise operations that synthesize efficiently
     * 4. The mask generation is a single operation that scales well
     * 5. Can be easily extended to more complex selection patterns
     */
endmodule