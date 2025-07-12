module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction and determine the results
    wire [3:0] diff;
    assign diff = A - B;

    // Determine A_greater
    assign A_greater = (diff > 0) && (A >= B);

    // Determine A_equal
    assign A_equal = (A == B);

    // Determine A_less
    assign A_less = (A < B);

    // Alternative implementation using explicit borrow
    // wire borrow;
    // assign borrow = (B > A);
    // assign A_greater = ~borrow && (diff != 0);
    // assign A_equal = ~borrow && (diff == 0);
    // assign A_less = borrow;

endmodule