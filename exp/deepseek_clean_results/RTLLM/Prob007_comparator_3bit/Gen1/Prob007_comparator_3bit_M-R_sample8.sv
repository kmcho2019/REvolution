module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Compare bit by bit from MSB to LSB
    wire greater = (A[2] > B[2]) ? 1'b1 :
                  (A[2] < B[2]) ? 1'b0 :
                  (A[1] > B[1]) ? 1'b1 :
                  (A[1] < B[1]) ? 1'b0 :
                  (A[0] > B[0]) ? 1'b1 : 1'b0;

    wire equal = (A == B);
    wire less = ~greater & ~equal;

    assign A_greater = greater;
    assign A_equal = equal;
    assign A_less = less;

endmodule