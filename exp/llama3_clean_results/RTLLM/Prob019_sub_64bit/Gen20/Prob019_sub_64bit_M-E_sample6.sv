module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    logic [63:0] temp_result;
    assign temp_result = A - B;
    assign result = temp_result;

    logic a_msbit, b_msbit, result_msbit;
    assign a_msbit = A[63];
    assign b_msbit = B[63];
    assign result_msbit = result[63];

    logic same_sign, different_sign;
    assign same_sign = (a_msbit == b_msbit);
    assign different_sign = (a_msbit != b_msbit);

    logic overflow_condition;
    assign overflow_condition = (different_sign && (a_msbit != result_msbit));

    assign overflow = overflow_condition;

endmodule