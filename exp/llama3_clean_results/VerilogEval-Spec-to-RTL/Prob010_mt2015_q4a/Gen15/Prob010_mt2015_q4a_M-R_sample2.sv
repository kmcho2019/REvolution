/**
 * Module TopModule implements the boolean function z = (x^y) & x directly within a single assign statement.
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of (x^y) & x.
 */
module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Directly implement the boolean function z = (x^y) & x using a single assign statement
assign z = x ? (x ^ y) : 1'b0;

endmodule