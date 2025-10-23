// Define the module TopModule with input ports a and b, and output port out
module TopModule(
    input  a,  // First input for the AND gate
    input  b,  // Second input for the AND gate
    output wire out  // Output of the AND gate, declared as wire for potential area optimization
);

// Implement the 2-input AND gate using a continuous assignment statement
// This approach is simple, efficient, and suitable for a basic logical operation
assign out = a & b;  // Perform the AND operation and assign the result to out

endmodule