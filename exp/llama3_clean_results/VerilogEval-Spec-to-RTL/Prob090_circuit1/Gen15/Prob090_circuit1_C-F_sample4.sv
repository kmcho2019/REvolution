module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    
// Implement the AND gate logic using continuous assignment for potential synthesis efficiency
assign q = a & b;

endmodule