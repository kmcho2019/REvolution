// TopModule: A combinational logic circuit implementing an AND operation with an inverted input
module TopModule(
    input  in1,  // First input
    input  in2,  // Second input with a bubble (inversion)
    output out   // Output of the AND operation
);

// Implementing the AND operation with an inverted input directly
// The bubble on in2 implies inversion, thus in1 & ~in2 directly implements the required logic
assign out = in1 & ~in2;  // Continuous assignment for combinational logic

endmodule