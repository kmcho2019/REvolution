module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire signed [4:0] diff; // 5 bits to represent signed difference with sign extension

    assign diff = {1'b0, A} - {1'b0, B};

    assign A_greater = (diff > 0);
    assign A_equal   = (diff == 0);
    assign A_less    = (diff < 0);

endmodule