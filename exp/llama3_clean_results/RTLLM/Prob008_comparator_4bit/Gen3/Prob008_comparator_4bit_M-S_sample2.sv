module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Direct comparison approach for simplicity and efficiency
    assign A_greater = (A > B);  // A is greater than B
    assign A_equal   = (A == B);  // A is equal to B
    assign A_less    = (A < B);   // A is less than B

endmodule