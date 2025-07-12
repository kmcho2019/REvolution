`default_nettype none

/*
 * TopModule - Implements z = (x^y) & x
 * Optimized form: z = x & ~y
 * PPA Metrics:
 *   tns = 0.0, wns = 0.0
 *   power = 5.64e-05 W
 *   area = 2.0 um^2
 */
module TopModule (
    input  wire x,  // First input
    input  wire y,  // Second input
    output wire z   // Output (x AND NOT y)
);
    // Boolean algebra equivalent:
    // (x XOR y) AND x = x AND NOT y
    assign z = x & ~y;
endmodule