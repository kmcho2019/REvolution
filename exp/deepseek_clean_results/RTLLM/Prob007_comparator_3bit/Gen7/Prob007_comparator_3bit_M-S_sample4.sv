module comparator_3bit (
    input [2:0] A, B,
    output A_greater, A_equal, A_less
);
    assign A_greater = A > B;
    assign A_equal = A == B;
    assign A_less = A < B;
endmodule