module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    reg [63:0] result_reg;
    reg        overflow_reg;

    always @(*) begin
        result_reg = A - B;
        overflow_reg = (A[63] != B[63] && A[63] != result_reg[63]) ? 1'b1 : 1'b0;
    end

    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule