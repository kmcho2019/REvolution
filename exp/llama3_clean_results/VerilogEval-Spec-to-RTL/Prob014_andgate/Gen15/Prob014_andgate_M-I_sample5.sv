// Module: TopModule
// Description: A top-level module implementing a 2-input AND gate directly.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Implement a 2-input AND gate using continuous assignment
assign out = a & b;

endmodule