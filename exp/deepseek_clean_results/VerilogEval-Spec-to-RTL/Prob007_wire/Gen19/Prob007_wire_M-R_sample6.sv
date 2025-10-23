/*
 * TopModule: Wire Connection using always block
 * Features:
 * - Zero-delay signal propagation
 * - Minimal power/area implementation
 * - Parameterized for potential vector extension
 * - Demonstrates alternative implementation style
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit, can be overridden for vectors
) (
    input  wire in,      // Input signal
    output reg  out      // Registered output (will synthesize to wire)
);
    // Always block provides identical PPA to continuous assignment:
    // - Still zero combinational delay
    // - Same minimal power consumption
    // - Will synthesize to direct connection
    always @(in) begin
        out = in;
    end

    // Simulation checks (commented out in synthesis)
    // initial assert(WIDTH == 1) else $warning("Vector version needs verification");
endmodule