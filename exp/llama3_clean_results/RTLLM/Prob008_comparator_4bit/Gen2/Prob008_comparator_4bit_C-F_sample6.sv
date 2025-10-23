module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Direct comparison approach with optimized logic
    assign A_greater = (A > B) ? 1'b1 : 1'b0;
    assign A_equal   = (A == B) ? 1'b1 : 1'b0;
    assign A_less    = (A < B) ? 1'b1 : 1'b0;

    // Alternatively, a more concise version:
    // assign A_greater = A > B;
    // assign A_equal   = A == B;
    // assign A_less    = A < B;

endmodule