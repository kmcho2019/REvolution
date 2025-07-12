module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Compute 4-bit subtraction result (A - B)
    wire [4:0] sub_result = {1'b0, A} - {1'b0, B};

    // Output assignments
    assign A_equal = (A == B);
    assign A_greater = ~A_equal & ~sub_result[4];  // No borrow and not equal
    assign A_less = ~A_equal & sub_result[4];     // Borrow occurred and not equal

endmodule