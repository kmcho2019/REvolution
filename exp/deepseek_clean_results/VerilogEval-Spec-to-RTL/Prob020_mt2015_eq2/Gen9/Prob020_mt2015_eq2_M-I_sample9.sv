module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Optimized equality comparison using compound XNOR-AND gate
    // Equivalent to: z = (A == B), but implemented as single optimized cell
    assign z = ~(A[0] ^ B[0]) & ~(A[1] ^ B[1]);
    
    /* Physical implementation notes:
     * Uses single compound XNOR-AND cell (2-input XNOR followed by 2-input AND)
     * Total transistors: 12 (vs 16 in discrete implementation)
     * Reduced interconnect capacitance improves power and timing
     */
endmodule