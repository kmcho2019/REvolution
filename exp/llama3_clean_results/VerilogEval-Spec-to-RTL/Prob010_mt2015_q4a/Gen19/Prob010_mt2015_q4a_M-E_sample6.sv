/**
 * Module TopModule implements the boolean function z = (x^y) & x using a multiplexer.
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

// Use a multiplexer to select between 0 and y based on x
assign z = x ? y : 0;

endmodule