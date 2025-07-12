// Refactored solution using an always_comb block
module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Use an always_comb block for combinational logic
always_comb begin
    // Assign the result of the AND operation to the output 'q'
    q = a & b;
end

endmodule