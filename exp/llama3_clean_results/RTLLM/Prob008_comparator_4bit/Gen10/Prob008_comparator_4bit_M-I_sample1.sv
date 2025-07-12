module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    assign diff = A - B;

    assign A_greater = (diff[3] == 0) && (diff != 4'b0);
    assign A_equal = (diff == 4'b0);
    assign A_less = (diff[3] == 1);

endmodule