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

// Perform the XOR operation
logic xor_result;  
assign xor_result = x ^ y;

// Use a multiplexer to select between the XOR result (when x = 1) and 0 (when x = 0)
assign z = x? xor_result : 1'b0;

endmodule