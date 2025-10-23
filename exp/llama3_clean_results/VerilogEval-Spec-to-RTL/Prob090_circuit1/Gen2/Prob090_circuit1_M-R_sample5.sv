module TopModule(
    input  logic a, // Declare as logic for clarity and modern Verilog practice
    input  logic b, // Declare as logic for clarity and modern Verilog practice
    output logic q  // Declare as logic for clarity and modern Verilog practice
);

// Use an always block for the combinational logic
always_comb begin
    // The logic remains an AND operation between inputs a and b
    q = a & b;
end

endmodule