module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;

    // Perform 4-bit subtraction with extended bit to detect negative result
    assign diff = {1'b0, A} - {1'b0, B};

    // A equals B when diff is zero
    assign A_equal = (diff == 4'b0000);

    // A greater than B when diff is positive (MSB=0) and not zero
    assign A_greater = (diff[3] == 1'b0) && (diff != 4'b0000);

    // A less than B when diff is negative (MSB=1)
    assign A_less = diff[3] == 1'b1;

endmodule