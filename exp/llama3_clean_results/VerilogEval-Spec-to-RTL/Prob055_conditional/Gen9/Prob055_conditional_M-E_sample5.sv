module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare a and b
    wire [7:0] ab_min;
    assign ab_min = (a < b)? a : b;

    // Compare c and d
    wire [7:0] cd_min;
    assign cd_min = (c < d)? c : d;

    // Compare ab_min and cd_min
    assign min = (ab_min < cd_min)? ab_min : cd_min;

endmodule