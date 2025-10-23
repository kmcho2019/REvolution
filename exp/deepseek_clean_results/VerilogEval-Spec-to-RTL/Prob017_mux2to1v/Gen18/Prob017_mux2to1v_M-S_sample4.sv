module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Simple ternary operator for each bit
    assign out = sel ? b : a;

    /* Advantages:
     * 1. More concise and readable code
     * 2. Likely to synthesize to standard multiplexer cells
     * 3. Reduced area (100 muxes vs 300 gates in previous implementation)
     * 4. Potentially better power efficiency (no mask generation)
     * 5. Clearer intent for both humans and synthesis tools
     */
endmodule