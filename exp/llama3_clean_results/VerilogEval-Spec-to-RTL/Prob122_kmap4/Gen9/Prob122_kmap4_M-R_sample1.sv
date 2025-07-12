// Define the TopModule with input and output ports
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    input c,  // Input signal c
    input d,  // Input signal d
    output out // Output signal
);

// Directly compute the output by XORing the XOR results of (a, b) and (c, d)
assign out = (a ^ b) ^ (c ^ d);

endmodule