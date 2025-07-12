/**
 * Module TopModule implements the boolean function z = (x^y) & x.
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of (x^y) & x.
 */
module TopModule(
    input  x,  // Input signal x
    input  y,  // Input signal y
    output z   // Output signal z
);

// Directly implement the boolean function using bitwise operators
assign z = (x ^ y) & x;

endmodule