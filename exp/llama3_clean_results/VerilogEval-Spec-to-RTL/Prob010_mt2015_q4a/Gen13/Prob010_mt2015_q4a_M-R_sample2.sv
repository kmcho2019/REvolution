/**
 * Module TopModule implements the boolean function z = (x^y) & x.
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

// Directly implement the XOR operation and then use a multiplexer-like assignment
// to select between the XOR result (when x = 1) and 0 (when x = 0)
assign z = x? (x ^ y) : 1'b0;

endmodule