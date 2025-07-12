module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Compare a and b, and c and d
    wire [7:0] min_ab, min_cd;
    assign min_ab = (a < b) ? a : b;
    assign min_cd = (c < d) ? c : d;

    // Compare min_ab and min_cd to determine the minimum value
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule