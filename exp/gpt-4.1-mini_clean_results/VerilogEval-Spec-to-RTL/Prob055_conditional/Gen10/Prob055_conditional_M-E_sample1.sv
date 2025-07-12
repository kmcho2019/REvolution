module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Compare a and b
    assign min_ab = (a < b) ? a : b;

    // Compare c and d
    assign min_cd = (c < d) ? c : d;

    // Compare min_ab and min_cd to find final minimum
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule