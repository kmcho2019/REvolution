// Module TopModule implements a NOR gate.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Directly implement the NOR operation.
// This line performs the NOR logic and assigns the result directly to the output.
assign out = ~(a | b);  // The '~' operator negates the result of the OR operation between 'a' and 'b'.

// The NOR gate's truth table is as follows:
// - a = 0, b = 0: out = 1
// - a = 0, b = 1: out = 0
// - a = 1, b = 0: out = 0
// - a = 1, b = 1: out = 0

endmodule