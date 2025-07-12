/**
 * Module TopModule implements the simplified boolean function z = (x & ~y).
 *
 * @param x  Input signal x.
 * @param y  Input signal y.
 * @param z  Output signal z, which is the result of (x & ~y).
 */
module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

// Directly implement the simplified boolean function
assign z = x & ~y;

endmodule