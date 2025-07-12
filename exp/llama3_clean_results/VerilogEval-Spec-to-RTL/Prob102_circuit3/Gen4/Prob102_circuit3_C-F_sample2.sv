module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

// Intermediate wires for clarity and modularity
wire ab;
wire cd;

// Assign values to intermediate wires using the logic from the second example
assign ab = a || b;
assign cd = c || d;

// Use the efficient logic expression for the output q
assign q = ab && cd;

// Alternatively, to directly implement the fused logic without intermediate wires:
// assign q = (a || b) && (c || d);

endmodule