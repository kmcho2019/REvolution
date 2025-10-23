// Module to implement an AND gate with one inverted input
module TopModule(
    input  in1,  // First input to the AND gate
    input  in2,  // Second input to the AND gate (inverted)
    output and_result  // Result of the AND operation
);

// Directly assign the output with explicit inversion of in2 for clarity and efficiency
assign and_result = in1 & (~in2);

endmodule