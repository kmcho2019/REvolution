// Module TopModule implements an XNOR gate using an XOR gate and an inverter
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wire for XOR operation
wire xor_result;  // Result of XOR operation between a and b

// XOR gate
assign xor_result = a ^ b;

// Inverter to get XNOR result
assign out = ~xor_result;

endmodule