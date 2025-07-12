module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B and check for borrow
    wire [3:0] diff;
    assign diff = A - B;

    // Determine A_greater
    assign A_greater = (diff[3] == 0 && diff != 4'b0000);

    // Determine A_equal
    assign A_equal = (diff == 4'b0000);

    // Determine A_less
    assign A_less = (diff[3] == 1);

endmodule