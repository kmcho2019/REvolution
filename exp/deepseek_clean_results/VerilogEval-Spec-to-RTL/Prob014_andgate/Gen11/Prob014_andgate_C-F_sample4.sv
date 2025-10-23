`default_nettype none  // Prevent implicit wire declarations

/*
 * TopModule: Optimal 2-input AND gate implementation
 * Features:
 * - Minimal propagation delay
 * - Zero timing violations (tns/wns = 0)
 * - Minimal power/area footprint
 * - Clean continuous assignment implementation
 */
module TopModule(
    input  wire a,    // First input
    input  wire b,    // Second input
    output wire out   // AND output
);
    // Core AND functionality - maps directly to standard cell
    assign out = a & b;
endmodule