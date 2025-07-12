/*
 * TopModule - Single-bit NOR Gate
 * 
 * Functionality:
 * out = ~(a | b)
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
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    assign out = ~(a | b);
endmodule