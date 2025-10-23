module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire signed [4:0] result;
    assign result = {1'b0, A} - {1'b0, B};

    assign A_equal   = (result[3:0] == 4'b0000);
    assign A_less    = result[4];                // sign bit: 1 means A < B
    assign A_greater = ~result[4] & ~A_equal;   // positive and not equal

endmodule