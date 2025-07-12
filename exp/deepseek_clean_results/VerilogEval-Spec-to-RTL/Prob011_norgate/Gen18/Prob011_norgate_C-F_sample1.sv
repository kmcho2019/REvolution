/*
 * TopModule - Optimized NOR Gate Implementation
 * 
 * Features:
 * - Direct NOR operation for optimal PPA
 * - Comprehensive documentation including truth table
 * - Clean interface matching specification
 * - Potential for future parameterization
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 * 
 * Architecture:
 * - Single continuous assignment implements NOR in most efficient way
 * - No unnecessary hierarchy for this simple function
 * - Maintains potential for scaling to multi-bit versions
 */

module TopModule (
    input  a,    // First input bit
    input  b,    // Second input bit
    output out   // NOR output
);
    // Optimal direct NOR implementation
    assign out = ~(a | b);
endmodule