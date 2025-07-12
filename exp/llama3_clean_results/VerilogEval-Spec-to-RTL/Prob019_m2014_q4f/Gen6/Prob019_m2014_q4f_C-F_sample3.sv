// TopModule: Implements a circuit with an AND gate where one input is inverted.
module TopModule(
    input  in1,  // First input to the AND gate
    input  in2,  // Second input to the AND gate, inverted
    output out    // Output of the AND gate
);

// Continuous assignment to implement the combinational logic
assign out = in1 & ~in2; // AND operation with in2 inverted

endmodule