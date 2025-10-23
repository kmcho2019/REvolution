/*
 * TopModule - Single-bit NOR Gate
 * 
 * Functionality:
 * Performs NOR operation between inputs a and b: out = ~(a | b)
 * 
 * Truth Table:
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 * 
 * Example Usage:
 * TopModule nor_gate (.a(input1), .b(input2), .out(result));
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Direct NOR implementation using continuous assignment
    assign out = ~(a | b);
endmodule