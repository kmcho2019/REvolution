/**
 * Module TopModule implements the boolean function z = (x^y) & x using a novel approach.
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

// Directly implement the logic based on the value of x
// When x is 0, z is always 0
// When x is 1, z equals y (since 1^y = y)
assign z = x && y;

endmodule