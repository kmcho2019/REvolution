module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform subtraction using simple ripple-carry adder
    wire [63:0] B_comp = ~B;
    wire [64:0] sum = A + B_comp + 1'b1;
    assign result = sum[63:0];

    // Overflow detection
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule