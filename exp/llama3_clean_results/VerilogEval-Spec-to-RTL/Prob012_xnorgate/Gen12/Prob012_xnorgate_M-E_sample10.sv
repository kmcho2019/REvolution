// Module TopModule implements an XNOR gate using AND, NOT, and OR gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires for AND operations and inversions
wire a_and_b;  // Both inputs high
wire not_a_and_not_b;  // Both inputs low

// AND gates for both inputs high and both inputs low
assign a_and_b = a & b;
assign not_a_and_not_b = (~a) & (~b);

// OR gate to combine the results
assign out = a_and_b | not_a_and_not_b;

endmodule