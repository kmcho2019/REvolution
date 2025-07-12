module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Calculate two's complement of B
    wire [63:0] B_comp;
    assign B_comp = ~B + 1;

    // Perform addition of A and B's two's complement
    wire [63:0] sum;
    assign sum = A + B_comp;

    // Assign result
    assign result = sum;

    // Detect overflow
    assign overflow = (A[63] == 0 && B[63] == 1 && sum[63] == 1) || (A[63] == 1 && B[63] == 0 && sum[63] == 0);

endmodule