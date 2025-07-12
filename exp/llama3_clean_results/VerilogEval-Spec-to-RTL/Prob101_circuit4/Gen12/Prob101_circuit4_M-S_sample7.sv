module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Simplified assignment directly implementing the OR logic
assign q = b | c;

endmodule