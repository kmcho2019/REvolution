module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction operation A - B
    wire [3:0] diff;
    assign diff = A - B;

    // Generate output signals based on the subtraction result
    assign A_greater = (diff[3] == 0) & (diff != 0);  // A is greater than B if no borrow and result is non-zero
    assign A_equal = (diff == 0);  // A is equal to B if result is zero
    assign A_less = (diff[3] == 1);  // A is less than B if borrow occurs

endmodule