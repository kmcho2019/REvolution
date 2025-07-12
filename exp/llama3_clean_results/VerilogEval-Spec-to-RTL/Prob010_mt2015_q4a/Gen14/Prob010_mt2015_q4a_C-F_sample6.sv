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

// Instantiate the XorModule to perform the XOR operation
XorModule xor_inst(
    .a(x),  // Connect input x to the first input of the XOR module
    .b(y),  // Connect input y to the second input of the XOR module
    .z(z)   // Directly connect the output of the XOR module to the output z after AND operation
);

// Perform the AND operation directly with the output of the XOR module and input x
// Since the output of the XOR module is directly connected to z, we can simplify the design
// by removing the explicit AND operation and instead, use the output of the XOR module
// in a way that it gets ANDed with x implicitly within the TopModule's logic.

// However, to maintain clarity and stick to the original function, we explicitly implement the AND
assign z = (xor_inst.z) & x;

endmodule