module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First, compare a and b, and assign the smaller value to min_ab
    wire [7:0] min_ab = (a < b)? a : b;

    // Then, compare c and d, and assign the smaller value to min_cd
    wire [7:0] min_cd = (c < d)? c : d;

    // Finally, compare min_ab and min_cd, and assign the smaller value to min
    assign min = (min_ab < min_cd)? min_ab : min_cd;

endmodule