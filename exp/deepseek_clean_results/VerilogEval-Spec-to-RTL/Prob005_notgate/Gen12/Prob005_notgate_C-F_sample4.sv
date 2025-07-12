module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation
    // Synthesis directives for optimal PPA:
    // - Use smallest available standard cell
    // - Prefer low-leakage cell if timing allows
    assign out = ~in;

    /* Potential optimization paths:
     * 1. Technology: Use high-Vt cells for low power if timing allows
     * 2. Layout: Place near fanout to minimize routing delays
     * 3. System: Consider merging with adjacent logic in larger designs
     */
endmodule