module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] xor_result;
    wire [3:0] sub_result;

    assign xor_result = A ^ B;
    assign A_equal = (xor_result == 4'b0000);

    assign sub_result = A - B;
    assign A_greater = (A_equal == 1'b0) && (sub_result[3] == 0);
    assign A_less = (A_equal == 1'b0) && (sub_result[3] == 1);

endmodule