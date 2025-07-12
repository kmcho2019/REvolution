/*
 * TopModule - Single-bit NOR Gate
 * 
 * Functionality: out = ~(a | b)
 */
module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    assign out = ~(a | b);
endmodule