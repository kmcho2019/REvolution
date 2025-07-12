// Module TopModule implements an XNOR gate using AND, OR, and NOT gates
// The XNOR operation outputs 1 when both inputs are the same (either both 0 or both 1), and outputs 0 otherwise
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output out // Output signal out
);

// Internal wires for NOT a and NOT b
wire not_a;
wire not_b;

// Compute NOT a and NOT b
assign not_a = ~a;
assign not_b = ~b;

// Compute (a AND b) and (NOT a AND NOT b)
wire and_ab;
wire and_not_ab;
assign and_ab = a & b;
assign and_not_ab = not_a & not_b;

// Compute the final XNOR result using OR
assign out = and_ab | and_not_ab;

endmodule