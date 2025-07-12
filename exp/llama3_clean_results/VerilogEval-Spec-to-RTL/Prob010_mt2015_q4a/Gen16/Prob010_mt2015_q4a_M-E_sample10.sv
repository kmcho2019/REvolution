/**
 * Module Mux2to1 implements a 2-to-1 multiplexer.
 *
 * @param sel  Select signal.
 * @param in0  First input signal.
 * @param in1  Second input signal.
 * @param out  Output signal, selected based on the sel signal.
 */
module Mux2to1(
    input  logic sel,  // Select signal
    input  logic in0,  // First input signal
    input  logic in1,  // Second input signal
    output logic out   // Output signal
);

// Implement the 2-to-1 multiplexer using logical operations
assign out = (sel)? in1 : in0;

endmodule

/**
 * Module XorModule implements the XOR operation between two inputs.
 *
 * @param a  First input signal.
 * @param b  Second input signal.
 * @param z  Output signal, result of a ^ b.
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
 * Module TopModule implements the boolean function z = (x^y) & x using a 2-to-1 multiplexer.
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

// Instantiate the Mux2to1 module to implement the AND operation
Mux2to1 mux_inst(
   .sel(x),  // Connect input x to the select signal of the multiplexer
   .in0(1'b0),  // Connect 0 to the first input of the multiplexer
   .in1(xor_result),  // Connect the XOR result to the second input of the multiplexer
   .out(z)  // Connect the output of the multiplexer to the output signal z
);

endmodule