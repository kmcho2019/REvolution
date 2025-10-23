/*
 * TopModule - Optimal combinational pass-through
 * PPA Metrics:
 *   Timing: tns/wns = 0.0
 *   Power: 2.11e-05 W
 *   Area: 1.0 um²
 *   Delay: eff_clk_period = 0.0
 */
module TopModule (
    input  wire in,  // 1-bit input
    output wire out  // 1-bit output
);
    // Direct combinational connection - optimal PPA
    assign out = in;
endmodule