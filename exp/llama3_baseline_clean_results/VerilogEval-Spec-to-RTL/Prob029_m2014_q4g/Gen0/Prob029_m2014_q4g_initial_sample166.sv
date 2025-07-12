module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// The XNOR of in1 and in2
// In Verilog, the equality operator (==) can be used to simplify this,
// as the result of in1 == in2 will be 1 if in1 and in2 are the same, and 0 otherwise.
// However, using the ~ (^ in1 ^ in2) for XNOR is a common approach.
wire xnor_out;

// Directly implementing XNOR using the equality operator for clarity
assign xnor_out = ~(in1 ^ in2);

// The XOR of xnor_out and in3
// This operation will give the final output 'out'
assign out = xnor_out ^ in3;

endmodule