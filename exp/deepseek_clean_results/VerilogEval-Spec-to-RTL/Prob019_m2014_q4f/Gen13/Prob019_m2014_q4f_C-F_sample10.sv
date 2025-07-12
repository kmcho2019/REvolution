module TopModule (
    input in1,
    input in2,
    output out
);
    /* Implementation options:
     * 1. Direct implementation (optimal for synthesis):
     *    assign out = in1 & ~in2;  // in1 AND (NOT in2)
     *
     * 2. Modular implementation (better for debug):
     *    wire in2_not = ~in2;
     *    assign out = in1 & in2_not;
     */
    
    // Using modular implementation for clarity
    wire in2_not;
    assign in2_not = ~in2;
    assign out = in1 & in2_not;
endmodule