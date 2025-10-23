module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] diff;

    assign diff = {1'b0, A} - {1'b0, B};

    assign A_less    = diff[4];         // borrow out indicates A < B
    assign A_equal   = (A == B);
    assign A_greater = (~A_less) & (~A_equal);

endmodule