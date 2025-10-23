/**
 * Module TopModule implements the boolean function z = (x^y) & x using a simplified logic expression.
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of the simplified logic expression.
 */
module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Directly implement the simplified boolean expression: z = x & ~y
assign z = x & ~y;

endmodule