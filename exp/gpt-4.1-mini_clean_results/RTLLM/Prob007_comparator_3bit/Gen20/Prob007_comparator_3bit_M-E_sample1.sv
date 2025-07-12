module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff; // 4-bit to catch overflow/sign bit

    // Subtract B from A
    assign diff = {1'b0, A} - {1'b0, B};

    // Determine equality by checking if diff is zero
    assign A_equal = (diff[2:0] == 3'b000);

    // If diff is zero, neither greater nor less
    // diff[3] is the sign bit after subtraction (borrow out)
    // diff[3] = 1 means A < B
    // diff[3] = 0 and diff != 0 means A > B

    assign A_less = (diff[3] == 1'b1);
    assign A_greater = (~diff[3]) & (~A_equal);

endmodule