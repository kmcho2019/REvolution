module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct output assignments using priority comparison
    assign A_equal = (A == B);
    assign A_greater = (A[3] > B[3]) ? 1'b1 :
                      (A[3] == B[3] && A[2] > B[2]) ? 1'b1 :
                      (A[3] == B[3] && A[2] == B[2] && A[1] > B[1]) ? 1'b1 :
                      (A[3] == B[3] && A[2] == B[2] && A[1] == B[1] && A[0] > B[0]) ? 1'b1 :
                      1'b0;
    assign A_less = ~A_equal & ~A_greater;

endmodule