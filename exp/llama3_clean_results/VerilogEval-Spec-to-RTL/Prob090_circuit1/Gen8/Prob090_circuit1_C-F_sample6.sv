module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);
    
// Direct and efficient implementation of the AND gate operation
assign q = a & b;

endmodule