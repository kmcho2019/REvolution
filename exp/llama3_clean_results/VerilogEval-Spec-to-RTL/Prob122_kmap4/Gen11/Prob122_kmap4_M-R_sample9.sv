module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire temp1; // Intermediate result for a and b
    wire temp2; // Intermediate result for c and d
    assign temp1 = a ^ b; // XOR operation for a and b
    assign temp2 = c ^ d; // XOR operation for c and d
    assign out = temp1 ^ temp2; // Final XOR operation for temp1 and temp2

endmodule