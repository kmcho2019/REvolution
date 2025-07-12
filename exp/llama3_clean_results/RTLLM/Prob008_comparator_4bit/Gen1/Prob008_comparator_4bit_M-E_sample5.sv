module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bits from MSB to LSB
    assign A_greater = (A[3] && !B[3]) ||
                       (!A[3] && B[3] ? 0 : A[2] && !B[2]) ||
                       (!A[3] && !B[3] && !A[2] && B[2] ? 0 : A[1] && !B[1]) ||
                       (!A[3] && !B[3] && !A[2] && !B[2] && !A[1] && B[1] ? 0 : A[0] && !B[0]);

    assign A_less = (!A[3] && B[3]) ||
                   (A[3] && !B[3] ? 0 : !A[2] && B[2]) ||
                   (A[3] && B[3] && !A[2] && !B[2] ? 0 : !A[1] && B[1]) ||
                   (A[3] && B[3] && A[2] && B[2] && !A[1] && !B[1] ? 0 : !A[0] && B[0]);

    assign A_equal = (!A_greater && !A_less);

endmodule