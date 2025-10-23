// Module: TopModule
// Description: Implements a NOT gate.
// Inputs: in - The input signal to be inverted.
// Outputs: out - The inverted output signal.

module TopModule(
    input  in,  // Input signal
    output out  // Output signal
);
    // Use the logical NOT operator (~) to invert the input signal.
    assign out = ~in;
endmodule