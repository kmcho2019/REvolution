module TopModule (
    input in1,
    input in2,
    output out
);
    /* Bubble notation indicates in2 is inverted before AND operation
     * Two equivalent implementations:
     * 1. Direct (recommended for optimal PPA):
     *    out = in1 AND (NOT in2)
     * 2. Modular (for debug/readability):
     *    wire in2_not = ~in2;
     *    out = in1 AND in2_not
     */
    
    // Using direct implementation for optimal PPA
    assign out = in1 & ~in2;
endmodule