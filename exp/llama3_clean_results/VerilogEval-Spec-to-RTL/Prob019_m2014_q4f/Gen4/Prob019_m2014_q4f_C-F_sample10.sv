// TopModule: A simple digital circuit implementing an AND gate with one inverted input.
module TopModule(
    input  in1,  // First input to the AND gate.
    input  in2,  // Second input to the AND gate, inverted.
    output out    // Output of the AND gate.
);

// The AND operation with an inverted input is directly implemented using a single assign statement.
assign out = in1 & ~in2;  // out is true only if in1 is true and in2 is false.

endmodule