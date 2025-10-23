module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);
    // Direct implementation of the inverse XOR of inputs a, b, c, and d
    assign q = ~(a ^ b ^ c ^ d);
endmodule