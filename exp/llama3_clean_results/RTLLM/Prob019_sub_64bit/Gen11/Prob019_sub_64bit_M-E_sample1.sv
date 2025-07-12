module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] diff;
    wire        carry_out;

    // Perform subtraction
    assign {carry_out, diff} = A - B;

    // Detect overflow by analyzing carry chain
    assign overflow = (A[63] == 1 && B[63] == 0 && diff[63] == 1) ||
                      (A[63] == 0 && B[63] == 1 && diff[63] == 0);

    assign result = diff;

endmodule