module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Directly assigning the result of the OR operation to q
assign q = b || c;

endmodule