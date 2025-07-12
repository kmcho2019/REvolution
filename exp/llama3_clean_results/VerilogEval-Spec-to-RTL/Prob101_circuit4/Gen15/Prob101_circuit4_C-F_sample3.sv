module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Directly implementing the logic expression b | c
assign q = b || c;

endmodule