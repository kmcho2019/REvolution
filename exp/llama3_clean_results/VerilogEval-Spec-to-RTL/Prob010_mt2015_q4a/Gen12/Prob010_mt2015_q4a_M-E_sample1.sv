/**
 * Module TopModule implements the boolean function z = (x^y) & x using a multiplexer-based approach.
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

// Calculate x^y
logic xor_result;  // Intermediate signal to hold the XOR result
assign xor_result = x ^ y;

// Use a multiplexer to select between 0 and xor_result based on x
assign z = x? xor_result : 0;

endmodule