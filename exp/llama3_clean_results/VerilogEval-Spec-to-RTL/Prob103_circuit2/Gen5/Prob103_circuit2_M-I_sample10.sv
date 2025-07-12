module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Improved implementation using a single XOR operation and a NOT gate
assign q = ~(a ^ b ^ c ^ d);

endmodule