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

// Use a multiplexer to select between x and ~x based on y
logic mux_out;  // Output of the multiplexer

// The multiplexer can be thought of as implementing the XOR operation (x^y)
// If y is 0, mux_out = x; if y is 1, mux_out = ~x
assign mux_out = (y) ? ~x : x;

// Perform the AND operation with x
assign z = mux_out & x;

endmodule