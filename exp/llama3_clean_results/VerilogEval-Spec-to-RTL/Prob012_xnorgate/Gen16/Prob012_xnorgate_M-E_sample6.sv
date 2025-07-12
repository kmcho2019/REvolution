// Module TopModule implements an XNOR gate using an XOR gate and an inverter
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wire to connect the XOR gate to the inverter
wire xor_out;  // Output of the XOR gate

// XOR gate to compare the inputs
assign xor_out = a ^ b;  // XOR operation

// Inverter to produce the final XNOR output
assign out = ~xor_out;  // Invert the XOR output to get XNOR

endmodule