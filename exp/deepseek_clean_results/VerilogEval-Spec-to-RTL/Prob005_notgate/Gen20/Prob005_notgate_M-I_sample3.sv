/*
 * TopModule: Single-bit NOT gate implementation
 * Features:
 * - Optimal PPA characteristics
 * - Technology-independent RTL
 * - Fully synthesizable
 */
module TopModule #() (
    // Input Ports
    input wire in,       // Input signal
    
    // Output Ports
    output wire out      // Inverted output
);

    // Core NOT gate implementation
    assign out = ~in;

    /* Synthesis Directives:
     * - set_dont_touch on this module for hierarchical synthesis
     * - use high-Vt cells when power-optimized
     * - drive strength auto-selection enabled
     */
endmodule