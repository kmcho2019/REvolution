module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Compare pairs of input values in parallel
    wire [7:0] ab_min, ab_max;
    wire [7:0] cd_min, cd_max;

    // Compare and swap a and b
    assign ab_min = (a < b)? a : b;
    assign ab_max = (a < b)? b : a;

    // Compare and swap c and d
    assign cd_min = (c < d)? c : d;
    assign cd_max = (c < d)? d : c;

    // Compare ab_min and cd_min to find the minimum
    assign min = (ab_min < cd_min)? ab_min : cd_min;

    // Alternative implementation with reduced comparisons
    // assign min = (a < b && a < c && a < d)? a :
    //             (b < a && b < c && b < d)? b :
    //             (c < a && c < b && c < d)? c : d;

endmodule