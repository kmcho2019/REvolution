// Module: TopModule
// Description: A simple 2-input AND gate implementation.
// 
// This module takes two input signals, 'a' and 'b', and produces an output 'out'
// that is the logical AND of 'a' and 'b'.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Implement a 2-input AND gate using a continuous assignment.
// This approach is efficient for combinational logic and minimizes area and power consumption.
assign out = a & b;

endmodule