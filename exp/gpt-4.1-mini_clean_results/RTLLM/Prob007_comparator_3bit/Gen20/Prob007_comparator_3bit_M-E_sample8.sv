module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff; // 4 bits to hold sign and result of subtraction

    assign diff = {1'b0, A} - {1'b0, B};

    assign A_equal   = (diff[2:0] == 3'b000);
    assign A_greater = ~diff[3] & ~A_equal; // MSB=0 means positive or zero (exclude zero)
    assign A_less    = diff[3];             // MSB=1 means negative

endmodule