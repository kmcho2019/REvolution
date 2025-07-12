module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Extended subtraction to 5 bits to detect borrow via MSB
    wire [4:0] diff_ext;
    assign diff_ext = {1'b0, A} - {1'b0, B};  // 5-bit subtraction to track borrow

    // Borrow occurs if MSB (diff_ext[4]) is set after subtraction (indicating A < B)
    wire borrow = diff_ext[4];

    // Check if difference is zero (all bits zero)
    wire diff_zero = (diff_ext[3:0] == 4'b0000);

    assign A_less    = borrow;
    assign A_equal   = (~borrow) & diff_zero;
    assign A_greater = (~borrow) & (~diff_zero);

endmodule