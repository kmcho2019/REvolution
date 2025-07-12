// Superior solution combining modern Verilog practices with simplicity
module TopModule(
    input  logic a, // Using logic type for modern Verilog practice
    input  logic b, // Using logic type for modern Verilog practice
    output logic q  // Using logic type for modern Verilog practice
);

// Using continuous assignment for simplicity and efficiency
assign q = a & b;

endmodule