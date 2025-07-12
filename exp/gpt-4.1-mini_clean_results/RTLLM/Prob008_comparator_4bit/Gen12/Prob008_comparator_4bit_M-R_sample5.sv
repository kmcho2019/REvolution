module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff_with_borrow;
    
    // Perform A - B with one extra bit to detect borrow (sign bit)
    assign diff_with_borrow = {1'b0, A} - {1'b0, B};

    // Borrow out occurs if the subtraction result is negative, i.e., MSB of diff_with_borrow is 1
    assign A_less = diff_with_borrow[4];

    // Equality if A equals B
    assign A_equal = (A == B);

    // Greater if not less and not equal
    assign A_greater = ~A_less & ~A_equal;

endmodule