/*
 * EnhancedTopModule - Priority-controlled OR gate
 * 
 * Functionality:
 *   Output q is normally the OR of b and c (q = b | c)
 *   Except when a=1 and d=0, where q is forced to 0
 * 
 * Truth Table:
 *   a d | Behavior
 *   ---|---------
 *   0 x | q = b | c
 *   1 0 | q = 0
 *   1 1 | q = b | c
 */
module TopModule (
    input  a,       // Priority control input
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Priority control input
    output q        // Conditional OR result
);

    // Priority-controlled OR operation
    assign q = (a & ~d) ? 1'b0 : (b | c);

endmodule