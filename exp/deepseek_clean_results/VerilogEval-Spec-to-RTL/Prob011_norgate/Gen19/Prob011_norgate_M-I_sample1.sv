/*
 * TopModule - Optimized 1-bit NOR Gate
 * 
 * Functionality: out = ~(a | b)
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    // Direct NOR implementation (optimal PPA)
    assign out = ~(a | b);
endmodule