module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Directly using the OR operator to implement the logic
assign q = b | c;

endmodule