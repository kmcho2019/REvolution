module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    
// Implement the AND gate logic using continuous assignment and logical AND operator
assign q = a && b;

endmodule