module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output logic [63:0] result,
    output logic overflow
);

    logic [63:0] sub_result;
    logic positive_overflow, negative_overflow;

    always_comb begin
        sub_result = A - B;
        result = sub_result;

        // Positive overflow: A positive, B negative, result negative
        positive_overflow = (~A[63] & B[63] & sub_result[63]);

        // Negative overflow: A negative, B positive, result positive
        negative_overflow = (A[63] & ~B[63] & ~sub_result[63]);

        overflow = positive_overflow | negative_overflow;
    end

endmodule