/*
 * TopModule - Optimized Single-bit NOR Gate
 * 
 * Functionality:
 * Performs NOR operation between inputs a and b: out = ~(a | b)
 * 
 * Implementation Notes:
 * - Direct NOR implementation for optimal PPA
 * - Alternative implementation (~a & ~b) may have better power
 *   characteristics in some technologies (De Morgan's equivalent)
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 * 
 * Usage Example:
 * TopModule nor1 (.a(a), .b(b), .out(out));
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Direct NOR implementation for optimal PPA
    assign out = ~(a | b);
    
    /* Alternative implementation (uncomment if better PPA in your technology):
     * assign out = ~a & ~b;  // De Morgan's equivalent
     */
endmodule