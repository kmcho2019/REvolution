module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Using a Buf (buffer) gate to improve performance
// However, since we're already using a simple assign statement,
// this might not result in any significant improvement
assign q = a & b;

endmodule