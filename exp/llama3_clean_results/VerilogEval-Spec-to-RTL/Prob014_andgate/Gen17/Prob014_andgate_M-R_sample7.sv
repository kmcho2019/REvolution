// Module: TopModule
// Description: A 2-input AND gate implementation using logical AND operator.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Directly assign the result of the AND operation to the output
assign out = a & b;

endmodule