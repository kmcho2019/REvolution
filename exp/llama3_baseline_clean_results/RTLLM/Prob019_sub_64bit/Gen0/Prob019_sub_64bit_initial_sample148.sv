module sub_64bit(
    input   wire [63:0] A,
    input   wire [63:0] B,
    output  wire [63:0] result,
    output  wire        overflow
);

    // Perform binary subtraction
    assign result = A - B;

    // Detect overflow conditions
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) ||
                      (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);

endmodule