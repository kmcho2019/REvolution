// Module TopModule implements an XNOR gate using AND and OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires to connect AND gates to the OR gate
wire both_zero;  // Condition for both inputs being 0
wire both_one;   // Condition for both inputs being 1

// AND gates to check for both inputs being 0 or both being 1
assign both_zero = ~a & ~b;  // Both inputs are 0
assign both_one = a & b;     // Both inputs are 1

// OR gate to combine the conditions for the final XNOR output
assign out = both_zero | both_one;

endmodule