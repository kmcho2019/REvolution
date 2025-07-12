module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] xor_result;
    assign xor_result = A ^ B;

    wire mismatch;
    assign mismatch = |xor_result;

    assign A_equal = ~mismatch;

    wire [3:0] and_result_A;
    assign and_result_A = A & xor_result;

    wire [3:0] and_result_B;
    assign and_result_B = B & xor_result;

    assign A_greater = (|and_result_A) & (~|and_result_B);
    assign A_less    = (|and_result_B) & (~|and_result_A);

endmodule