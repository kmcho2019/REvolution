module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    // Calculate -B by inverting all bits of B and adding 1
    logic [63:0] neg_B;
    assign neg_B = ~B + 1;

    // Perform A - B as A + (-B)
    logic [64:0] sum;
    assign sum = A + neg_B;

    // Extract the result and overflow
    assign result = sum[63:0];
    assign overflow = (sum[64] == 1) ? 1'b1 : 1'b0;

endmodule