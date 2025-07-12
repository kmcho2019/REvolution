module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    assign diff = A - B;

    assign A_equal = (A == B);
    assign A_greater = (~A_equal) && (diff[3] == 0);
    assign A_less = (~A_equal) && (diff[3] == 1);

endmodule