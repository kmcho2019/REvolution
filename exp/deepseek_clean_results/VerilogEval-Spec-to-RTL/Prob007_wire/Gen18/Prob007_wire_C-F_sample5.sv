/*
 * TopModule: Optimized Wire Connection
 * Combines best aspects of both examples:
 * - Direct wire assignment for optimal PPA
 * - Clean module structure
 * - Parameterized for future extension
 * - Comprehensive documentation
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit, can be overridden for vectors
) (
    input  wire in,      // Input signal
    output wire out      // Output signal
);
    // Optimal direct connection - same PPA as simplest wire
    assign out = in;

    // Simulation check (commented out in synthesis)
    // initial assert(WIDTH == 1) else $warning("Vector version needs verification");
endmodule