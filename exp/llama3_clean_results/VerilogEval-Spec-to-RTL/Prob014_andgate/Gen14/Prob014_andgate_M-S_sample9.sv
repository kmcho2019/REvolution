// Module: TopModule
// Description: A simplified 2-input AND gate implementation using continuous assignment.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Implement a 2-input AND gate using continuous assignment for simplicity
assign out = a & b;

endmodule