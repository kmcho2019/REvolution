/*
 * TopModule: Buffered Wire with Small Delay
 * Features:
 * - Provides small, consistent propagation delay
 * - Better noise immunity than direct wire
 * - Maintains signal polarity
 */
module TopModule (
    input  in,      // Input signal
    output out      // Buffered output with small delay
);

    // Internal buffer chain
    wire intermediate;
    
    // First inverter
    not U1 (intermediate, in);
    
    // Second inverter to restore polarity
    not U2 (out, intermediate);

    /* Note: This creates a small, consistent delay
     * while maintaining the original signal value.
     * The delay is determined by the inverter propagation times.
     */
endmodule