// Refactored Module TopModule: Using always_comb for combinational logic
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use always_comb to ensure combinational logic
always_comb begin
    out = in; // Direct assignment within always_comb for combinational logic
end

endmodule