module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // First stage: Compare MSB
    wire msb_equal;
    assign msb_equal = (A[3] == B[3]);

    // Second stage: Compare remaining bits
    wire [2:0] A_remaining;
    wire [2:0] B_remaining;
    assign A_remaining = A[2:0];
    assign B_remaining = B[2:0];

    wire A_remaining_greater;
    wire A_remaining_equal;
    wire A_remaining_less;
    assign A_remaining_greater = (A_remaining > B_remaining);
    assign A_remaining_equal = (A_remaining == B_remaining);
    assign A_remaining_less = (A_remaining < B_remaining);

    // Final result
    assign A_greater = (~msb_equal && A[3]) || (msb_equal && A_remaining_greater);
    assign A_equal = msb_equal && A_remaining_equal;
    assign A_less = (~msb_equal && ~A[3]) || (msb_equal && A_remaining_less);

endmodule