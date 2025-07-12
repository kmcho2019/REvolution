module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Determine if A is equal to B
    assign A_equal = (A == B);

    // Determine if A is greater than B when A is not equal to B
    assign A_greater = (~A_equal) && (A > B);

    // Determine if A is less than B when A is not equal to B
    assign A_less = (~A_equal) && (A < B);

endmodule