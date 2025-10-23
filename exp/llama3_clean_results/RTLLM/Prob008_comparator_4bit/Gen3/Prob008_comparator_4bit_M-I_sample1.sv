module comparator_4bit(
    input  [3:0] A,
    output       A_greater,
    output       A_equal,
    output       A_less,
    input  [3:0] B
);

    assign A_greater = (A > B)? 1'b1 : 1'b0;
    assign A_equal   = (A == B)? 1'b1 : 1'b0;
    assign A_less    = (A < B)? 1'b1 : 1'b0;

endmodule