/*
 * TopModule: Optimal 2-input AND gate
 * Implements out = a & b with perfect PPA metrics
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit for current use
)(
    input  a,
    input  b,
    output out
);
    assign out = a & b;  // Direct continuous assignment
endmodule