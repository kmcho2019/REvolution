module TopModule(
    input  logic a, // Declare as logic for clarity and modern Verilog practice
    input  logic b, // Declare as logic for clarity and modern Verilog practice
    output logic q  // Declare as logic for clarity and modern Verilog practice
);

// Use continuous assignment for the combinational logic
assign q = a & b; // Directly assign the result of a AND b to q

endmodule