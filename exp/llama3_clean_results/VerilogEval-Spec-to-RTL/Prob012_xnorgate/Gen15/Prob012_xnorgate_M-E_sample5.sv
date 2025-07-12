// Module TopModule implements an XNOR gate using AND and OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires for AND operations
wire both_zero;  // Result of a AND (NOT b)
wire both_one;   // Result of (NOT a) AND b

// AND gates to check for both 0 and both 1 conditions
assign both_zero = ~(a | b);  // Corrected to check both inputs are 0
assign both_one = a & b;      // Check both inputs are 1

// OR gate to combine both conditions
assign out = both_zero | both_one;

endmodule