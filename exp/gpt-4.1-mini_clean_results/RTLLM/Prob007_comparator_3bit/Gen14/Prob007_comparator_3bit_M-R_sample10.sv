module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff; // 4-bit to capture possible borrow

    // Subtract B from A
    assign diff = {1'b0, A} - {1'b0, B};

    // Equality: diff is zero
    assign A_equal   = (diff == 4'b0000);

    // A greater if diff MSB (sign) is 0 and diff != 0
    assign A_greater = (~diff[3]) & (~A_equal);

    // A less otherwise (diff MSB is 1)
    assign A_less    = diff[3];

endmodule