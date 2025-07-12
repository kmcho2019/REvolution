module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Directly implementing the required logic as a single assignment statement
assign out = ~(in3 ^ ~(in1 ^ in2));

// Alternatively, breaking it down into steps for better readability
// reg xnor_out;
// assign xnor_out = ~(in1 ^ in2); // XNOR of in1 and in2
// assign out = xnor_out ^ in3; // XOR of XNOR result and in3

endmodule