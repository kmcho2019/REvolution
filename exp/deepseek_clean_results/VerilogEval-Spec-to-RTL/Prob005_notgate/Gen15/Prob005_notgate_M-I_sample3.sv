module TopModule (
    input in,
    output out
);
    // Direct NOT gate implementation
    assign out = ~in;
    
    /* Advantages:
     * 1. Minimal area (single gate)
     * 2. Lowest possible power consumption
     * 3. Best possible timing (single gate delay)
     * 4. Clear and maintainable code
     * 5. Technology portable
     */
endmodule