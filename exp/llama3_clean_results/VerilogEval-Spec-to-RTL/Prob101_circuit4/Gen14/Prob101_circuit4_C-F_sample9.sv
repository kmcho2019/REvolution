module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Directly implementing the OR operation for simplicity and efficiency
assign q = b | c;

endmodule