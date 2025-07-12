/*
 * TopModule - NOR Gate Implementation
 * 
 * Function: out = ~(a | b)
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 *
 * Note: For power optimization in some technologies,
 * can alternatively implement as ~a & ~b (De Morgan's equivalent)
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Direct NOR implementation (optimal for PPA)
    assign out = ~(a | b);
    
    /* For multi-bit version (future expansion):
     * module TopModule #(parameter WIDTH=1) (
     *     input [WIDTH-1:0] a, b,
     *     output [WIDTH-1:0] out
     * );
     *     assign out = ~(a | b);
     * endmodule
     */
endmodule