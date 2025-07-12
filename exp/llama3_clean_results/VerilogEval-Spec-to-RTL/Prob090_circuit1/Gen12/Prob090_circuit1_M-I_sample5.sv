module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

// Explicitly define the AND operation for potential area optimization
always_comb begin
    q = a & b;
end

endmodule