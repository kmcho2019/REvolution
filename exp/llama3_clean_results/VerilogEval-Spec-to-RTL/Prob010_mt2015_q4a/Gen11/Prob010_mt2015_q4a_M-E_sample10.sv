/**
 * Module TopModule implements the boolean function z = (x^y) & x using multiplexers.
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

// Internal signal to hold the result of x^y
logic xor_result;

// Calculate x^y
assign xor_result = x ^ y;

// Use a multiplexer to conditionally select between xor_result and 0 based on x
assign z = x ? xor_result : 1'b0;

endmodule