module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Direct comparisons for greater and equal
    assign A_greater = (A > B);
    assign A_equal   = (A == B);

    // Derive less signal by exclusion, ensuring mutual exclusivity and minimizing logic
    assign A_less    = ~(A_greater | A_equal);

endmodule