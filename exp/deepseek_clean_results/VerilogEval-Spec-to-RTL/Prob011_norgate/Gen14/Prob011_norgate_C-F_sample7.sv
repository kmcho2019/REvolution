/*
 * NOR Gate Module
 * Implements logical NOR operation between inputs a and b
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule(
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    assign out = ~(a | b);
endmodule