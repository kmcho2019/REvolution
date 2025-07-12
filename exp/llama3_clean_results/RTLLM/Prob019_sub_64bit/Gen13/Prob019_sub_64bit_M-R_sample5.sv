module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] diff;
    reg  [63:0] result_reg;
    reg          overflow_reg;

    assign diff = A - B;

    always @(*) begin
        result_reg = diff;
        overflow_reg = (A[63] == 1 && B[63] == 0 && diff[63] == 0) || (A[63] == 0 && B[63] == 1 && diff[63] == 1);
    end

    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule