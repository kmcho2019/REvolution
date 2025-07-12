// Novel Module TopModule implements an XNOR gate using AND, OR, and NOT gates
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Calculate NOT a and NOT b
wire not_a = ~a;
wire not_b = ~b;

// Perform AND operations
wire and_ab = a & b;
wire and_not_ab = not_a & not_b;

// Perform OR operation
wire or_result = and_ab | and_not_ab;

// Assign the result to the output
assign out = or_result;

endmodule