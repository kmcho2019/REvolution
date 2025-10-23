module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Implementing the correct logic expression
assign q = b | c | (a & d);

endmodule