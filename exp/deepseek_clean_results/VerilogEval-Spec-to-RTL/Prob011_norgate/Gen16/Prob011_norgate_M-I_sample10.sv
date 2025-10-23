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
 * Usage Example:
 * TopModule nor1 (.a(a), .b(b), .out(out));
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Direct NOR implementation
    assign out = ~(a | b);
endmodule