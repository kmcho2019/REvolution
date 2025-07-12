// Module TopModule implements a simple logic circuit with two inputs (in1 and in2) and one output (out).
// The output 'out' is the result of an AND operation between 'in1' and the inverted 'in2'.
module TopModule(
    input  in1,  // First input to the AND gate
    input  in2,  // Second input to the AND gate, inverted due to the bubble
    output out   // Output of the AND gate
);

// Assign the result of the AND operation between in1 and the inverted in2 to out
assign out = in1 & ~in2;

endmodule