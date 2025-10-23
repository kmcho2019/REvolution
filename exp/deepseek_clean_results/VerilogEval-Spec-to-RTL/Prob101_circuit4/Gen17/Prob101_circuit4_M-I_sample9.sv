/*
 * TopModule - Combinational logic module
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 * 
 * Truth Table:
 *   q = b | c
 */
module TopModule (
    input  b,       // First OR operand
    input  c,       // Second OR operand
    output q        // OR result of b and c
);

    assign q = b | c;

endmodule