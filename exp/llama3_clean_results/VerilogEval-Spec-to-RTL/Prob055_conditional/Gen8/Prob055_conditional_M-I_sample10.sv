module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare a and b
    wire [7:0] ab_min, ab_max;
    assign ab_min = (a < b)? a : b;
    assign ab_max = (a < b)? b : a;

    // Compare c and d
    wire [7:0] cd_min, cd_max;
    assign cd_min = (c < d)? c : d;
    assign cd_max = (c < d)? d : c;

    // Compare ab_min and cd_min
    wire [7:0] abcd_min;
    assign abcd_min = (ab_min < cd_min)? ab_min : cd_min;

    // The minimum value is the result of the final comparison
    assign min = abcd_min;

endmodule