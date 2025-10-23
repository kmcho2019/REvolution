/**
 * Module XorModule implements the XOR operation between two inputs.
 *
 * @param a  First input signal.
 * @param b  Second input signal.
 * @param z  Output signal, which is the result of a ^ b.
 */
module XorModule(
    input  logic a,  // First input signal
    input  logic b,  // Second input signal
    output logic z   // Output signal, result of a ^ b
);

// Directly implement the XOR operation
assign z = a ^ b;

endmodule

/**
 * Module TopModule implements the boolean function z = (x^y) & x using a hierarchical design approach and optimized logic structure.
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

// Instantiate the XorModule to perform the XOR operation
logic xor_result;  // Intermediate signal to hold the XOR result

XorModule xor_inst(
    .a(x),  // Connect input x to the first input of the XOR module
    .b(y),  // Connect input y to the second input of the XOR module
    .z(xor_result)  // Connect the output of the XOR module to the intermediate signal
);

// Use a multiplexer-like assignment to select between the XOR result (when x = 1) and 0 (when x = 0)
assign z = x ? xor_result : 1'b0;

endmodule