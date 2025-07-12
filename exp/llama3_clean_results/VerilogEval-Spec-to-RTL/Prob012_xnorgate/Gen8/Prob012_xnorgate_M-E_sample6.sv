// Module TopModule implements an XNOR gate using basic logical operations
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Use the property that XNOR(a, b) = NOT(XOR(a, b)) and implement XOR using AND and OR gates
// Then, apply negation to get XNOR
wire xor_result; // Intermediate wire to hold the result of the XOR operation
assign xor_result = (a & ~b) | (~a & b); // Implement XOR using AND and OR gates
assign out = ~xor_result; // Negate the XOR result to get XNOR

endmodule