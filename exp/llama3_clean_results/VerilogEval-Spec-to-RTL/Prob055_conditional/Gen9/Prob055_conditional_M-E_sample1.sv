module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Stage 1: Compare and swap a and b, c and d
    wire [7:0] ab_min, ab_max;
    wire [7:0] cd_min, cd_max;
    assign ab_min = (a < b)? a : b;
    assign ab_max = (a < b)? b : a;
    assign cd_min = (c < d)? c : d;
    assign cd_max = (c < d)? d : c;

    // Stage 2: Compare and swap ab_min and cd_min, ab_max and cd_max
    wire [7:0] abcd_min1, abcd_max1;
    wire [7:0] abcd_min2, abcd_max2;
    assign abcd_min1 = (ab_min < cd_min)? ab_min : cd_min;
    assign abcd_max1 = (ab_min < cd_min)? cd_min : ab_min;
    assign abcd_min2 = (ab_max < cd_max)? ab_max : cd_max;
    assign abcd_max2 = (ab_max < cd_max)? cd_max : ab_max;

    // Stage 3: Compare and swap abcd_min1 and abcd_min2
    assign min = (abcd_min1 < abcd_min2)? abcd_min1 : abcd_min2;

endmodule