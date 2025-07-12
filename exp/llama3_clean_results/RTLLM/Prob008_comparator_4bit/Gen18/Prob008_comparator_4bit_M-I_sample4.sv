module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output wire A_greater,
    output wire A_equal,
    output wire A_less
);

    wire [3:0] diff;
    assign diff = A - B;

    assign A_equal = (diff == 4'b0);
    assign A_greater = (A > B) &&!A_equal;
    assign A_less = (A < B) &&!A_equal;

    // Alternative implementation using bit-level operations
    // assign A_equal = (A == B);
    // assign A_greater = (A[3] > B[3]) || ((A[3] == B[3]) && (A[2] > B[2])) || ((A[3] == B[3]) && (A[2] == B[2]) && (A[1] > B[1])) || ((A[3] == B[3]) && (A[2] == B[2]) && (A[1] == B[1]) && (A[0] > B[0]));
    // assign A_less = (A[3] < B[3]) || ((A[3] == B[3]) && (A[2] < B[2])) || ((A[3] == B[3]) && (A[2] == B[2]) && (A[1] < B[1])) || ((A[3] == B[3]) && (A[2] == B[2]) && (A[1] == B[1]) && (A[0] < B[0]));

endmodule