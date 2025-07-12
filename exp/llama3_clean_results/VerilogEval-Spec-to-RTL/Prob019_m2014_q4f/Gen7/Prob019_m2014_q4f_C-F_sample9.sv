// TopModule implements an AND gate with one inverted input.
module TopModule(
    input  in1,  // First input of the AND gate
    input  in2,  // Second input of the AND gate, which is inverted
    output out    // Output of the AND gate
);

// Directly use the AND operation with one input inverted
// This is the most efficient way to implement this combinational logic
assign out = in1 & (~in2);

endmodule