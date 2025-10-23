module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

// Directly implement the logic for q without intermediate wires
assign q = (a || b) && (c || d);

// Alternatively, to explore different logic expressions that might yield the same functionality:
// assign q = (a && c) || (a && d) || (b && c) || (b && d);

endmodule