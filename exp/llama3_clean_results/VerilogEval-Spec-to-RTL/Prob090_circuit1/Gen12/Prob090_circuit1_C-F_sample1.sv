module TopModule(
    input  logic a, // Explicitly declare input ports with logic type
    input  logic b, // Explicitly declare input ports with logic type
    output logic q  // Explicitly declare output port with logic type
);

// Use an always_comb block for clear definition of combinational logic
always_comb begin
    // Directly implement the AND operation for efficiency and clarity
    q = a & b;
end

endmodule