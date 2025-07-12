module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    reg [4:0] diff;

    assign diff = {1'b0, A} - {1'b0, B};

    assign A_greater = diff[4] == 0 && diff[3:0] != 0;
    assign A_equal = diff[4:0] == 0;
    assign A_less = diff[4] == 1;

endmodule