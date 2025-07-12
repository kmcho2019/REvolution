module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Efficient implementation using ternary operator at top level
    // Synthesis tools will optimize this to the most efficient implementation
    assign out = sel ? b : a;

    /* Design Advantages:
     * 1. Clean and readable code (like Example 1)
     * 2. Direct expression of mux functionality
     * 3. Allows synthesis tools to choose between:
     *    - Simple ternary implementation
     *    - Mask-based implementation (like Example 2)
     *    - Technology-specific mux primitives
     * 4. Maintains optimal timing characteristics
     * 5. Scales perfectly to any bus width
     */
endmodule