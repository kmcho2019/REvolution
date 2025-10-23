module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Sorting network stage 1
    wire [7:0] a_b_min;
    wire [7:0] a_b_max;
    assign a_b_min = (a < b)? a : b;
    assign a_b_max = (a > b)? a : b;

    wire [7:0] c_d_min;
    wire [7:0] c_d_max;
    assign c_d_min = (c < d)? c : d;
    assign c_d_max = (c > d)? c : d;

    // Sorting network stage 2
    wire [7:0] ab_cd_min;
    wire [7:0] ab_cd_max;
    assign ab_cd_min = (a_b_min < c_d_min)? a_b_min : c_d_min;
    assign ab_cd_max = (a_b_min > c_d_min)? a_b_min : c_d_min;

    wire [7:0] ab_cd_max2;
    assign ab_cd_max2 = (a_b_max < c_d_max)? a_b_max : c_d_max;

    // Sorting network stage 3
    assign min = (ab_cd_min < ab_cd_max)? ab_cd_min : ab_cd_max;

endmodule