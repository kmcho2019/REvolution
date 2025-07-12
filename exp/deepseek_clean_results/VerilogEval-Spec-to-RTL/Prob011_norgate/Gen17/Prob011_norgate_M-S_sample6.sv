/*
 * Simplified NOR Gate Implementation
 * 
 * Architecture:
 * - Direct implementation of NOR function
 * - Single continuous assignment
 * - Most efficient implementation for this simple gate
 */

module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);
endmodule