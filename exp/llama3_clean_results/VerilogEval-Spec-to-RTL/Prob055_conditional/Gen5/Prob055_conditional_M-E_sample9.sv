module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Define the sorting network
    wire [7:0] ab_min, ab_max;
    wire [7:0] cd_min, cd_max;
    wire [7:0] abcd_min, abcd_max;
    wire [7:0] abcd_mid1, abcd_mid2;

    // Compare and swap a and b
    assign ab_min = (a < b) ? a : b;
    assign ab_max = (a < b) ? b : a;

    // Compare and swap c and d
    assign cd_min = (c < d) ? c : d;
    assign cd_max = (c < d) ? d : c;

    // Compare and swap ab_min and cd_min
    assign abcd_min = (ab_min < cd_min) ? ab_min : cd_min;
    assign abcd_max = (ab_min < cd_min) ? cd_max : ab_max;

    // The minimum value is now in abcd_min
    assign min = abcd_min;

endmodule