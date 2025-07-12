module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct comparison using ternary operators with MSB priority
assign A_greater = (A[2] > B[2]) ? 1'b1 :
                   (A[2] == B[2] && A[1] > B[1]) ? 1'b1 :
                   (A[2] == B[2] && A[1] == B[1] && A[0] > B[0]) ? 1'b1 : 1'b0;

assign A_equal = (A == B) ? 1'b1 : 1'b0;

// A_less is only true when neither greater nor equal
assign A_less = ~(A_greater | A_equal);

endmodule