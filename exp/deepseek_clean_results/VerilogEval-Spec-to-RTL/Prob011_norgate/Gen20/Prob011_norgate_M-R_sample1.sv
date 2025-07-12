/*
 * TopModule - 1-bit NOR Gate
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
    input  a,
    input  b,
    output out
);
    assign out = ~(a | b);
endmodule