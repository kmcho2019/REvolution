module TopModule(
    input  [1:0] A,
    input  [1:0] B,
    output z
);

// Use XOR operation to compare A and B, then check if the result is zero.
assign z = ~(A ^ B);

endmodule