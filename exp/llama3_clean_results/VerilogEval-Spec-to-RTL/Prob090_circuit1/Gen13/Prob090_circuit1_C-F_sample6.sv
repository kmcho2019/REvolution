module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Use an always_comb block for flexibility and modern Verilog practice
always_comb begin
    // Implement the AND operation directly for simplicity and synthesis optimization
    q = a & b;
end

endmodule