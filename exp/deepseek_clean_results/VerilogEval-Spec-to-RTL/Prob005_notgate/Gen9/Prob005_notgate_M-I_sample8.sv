/**
 * TopModule: Single-bit NOT gate implementation
 * Implements out = ~in with optimal PPA characteristics
 */
module TopModule (
    input  wire in,    // Single-bit input
    output wire out    // Inverted output
);
    // Continuous assignment provides optimal implementation
    assign out = ~in;
endmodule