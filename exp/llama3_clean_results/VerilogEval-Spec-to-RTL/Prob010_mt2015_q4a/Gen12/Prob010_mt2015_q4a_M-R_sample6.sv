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

// Directly calculate the XOR of x and y and store the result
logic xor_result;  
assign xor_result = x ^ y;

// Perform the AND operation using the XOR result and input x to get the final output z
assign z = xor_result & x;

endmodule