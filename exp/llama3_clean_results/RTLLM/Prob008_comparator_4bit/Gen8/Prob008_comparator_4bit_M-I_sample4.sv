module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    assign diff = A - B;
    
    assign A_equal = (A == B);
    assign A_greater = (A > B) && (~A_equal);
    assign A_less = (A < B) && (~A_equal);

    // Alternatively, for more explicit bit-level comparison and potential area reduction:
    // assign A_greater = (A[3] > B[3]) || (A[3] == B[3] && (A[2] > B[2] || (A[2] == B[2] && (A[1] > B[1] || (A[1] == B[1] && A[0] > B[0])))));
    // assign A_less = (A[3] < B[3]) || (A[3] == B[3] && (A[2] < B[2] || (A[2] == B[2] && (A[1] < B[1] || (A[1] == B[1] && A[0] < B[0])))));

endmodule