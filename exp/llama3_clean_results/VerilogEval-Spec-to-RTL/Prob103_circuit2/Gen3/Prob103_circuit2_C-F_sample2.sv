module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Direct implementation of the inverse XOR operation for clarity and efficiency
assign q = ~(a ^ b ^ c ^ d);

endmodule