// Module: TopModule
// Description: A simple 2-input AND gate implementation.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Implement a 2-input AND gate using a continuous assignment
// Note: For potential power improvements, consider synthesis options
// or library selections that favor low-power implementations.
assign out = a & b;

endmodule