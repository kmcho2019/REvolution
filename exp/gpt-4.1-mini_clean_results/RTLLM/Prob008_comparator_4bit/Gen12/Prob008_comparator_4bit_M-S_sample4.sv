module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff_full;
    assign diff_full = {1'b0, A} - {1'b0, B}; // 5-bit subtract to capture borrow in MSB

    wire borrow = diff_full[4];
    wire zero = (diff_full[3:0] == 4'b0000);

    assign A_less    = borrow;
    assign A_equal   = ~borrow & zero;
    assign A_greater = ~borrow & ~zero;

endmodule