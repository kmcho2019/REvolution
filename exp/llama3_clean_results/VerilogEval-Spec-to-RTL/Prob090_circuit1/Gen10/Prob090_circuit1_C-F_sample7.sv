module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    
// Directly implement the AND gate logic using continuous assignment
assign q = a & b;

endmodule