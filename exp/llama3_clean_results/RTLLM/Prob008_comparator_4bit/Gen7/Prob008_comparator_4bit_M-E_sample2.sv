module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] result;
    wire borrow;

    assign {borrow, result} = A - B;

    assign A_equal = (result == 4'b0000) && (borrow == 1'b0);
    assign A_greater = (result!= 4'b0000) && (borrow == 1'b0);
    assign A_less = borrow;

endmodule