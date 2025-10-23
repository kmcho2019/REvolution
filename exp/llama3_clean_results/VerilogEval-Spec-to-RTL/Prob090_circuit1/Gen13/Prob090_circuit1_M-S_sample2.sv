// Simplified solution using a basic AND gate
module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Assign the output as the logical AND of inputs a and b
assign q = a & b;

endmodule