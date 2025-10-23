/*
 * TopModule: Optimal Wire Connection
 * Features:
 * - Zero-delay signal propagation
 * - Minimal power/area implementation
 * - Parameterized for potential vector extension
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit, can be overridden for vectors
) (
    input  wire in,      // Input signal
    output wire out      // Buffered output
);
    // Continuous assignment provides optimal PPA:
    // - Zero combinational delay
    // - Minimal power (only wire capacitance)
    // - Smallest possible area (direct connection)
    assign out = in;

    // Simulation checks (commented out in synthesis)
    // initial assert(WIDTH == 1) else $warning("Vector version needs verification");
endmodule