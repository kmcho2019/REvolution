// Module: TopModule
// Description: 2-input NOR gate
// Inputs: in1, in2
// Outputs: out

module TopModule(
    input  in1,  // First input
    input  in2,  // Second input
    output out    // Output of the NOR gate
);

// Assign the output using a logical expression
// The NOR gate produces an output of 1 only if both inputs are 0
assign out = ~(in1 | in2);  // Using the logical NOT and OR operators

endmodule