module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;

    // Subtract B from A, extend to 4 bits for sign detection
    assign diff = {1'b0, A} - {1'b0, B};

    // Equality: diff is zero
    assign A_equal = (diff == 4'b0000);

    // A greater if diff is positive (MSB=0) and not zero
    assign A_greater = (~diff[3]) & ~A_equal;

    // A less if diff is negative (MSB=1)
    assign A_less = diff[3];

endmodule