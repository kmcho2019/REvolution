module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute signed difference A - B
    wire signed [3:0] diff = {1'b0, A} - {1'b0, B};

    assign A_equal   = (diff == 0);
    assign A_greater = (diff > 0);
    assign A_less    = (diff < 0);

endmodule