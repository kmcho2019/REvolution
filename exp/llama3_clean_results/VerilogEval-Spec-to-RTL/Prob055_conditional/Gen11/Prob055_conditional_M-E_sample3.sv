module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Stage 1: Compare and swap a, b
    wire [7:0] ab_min;
    wire [7:0] ab_max;
    assign ab_min = (a < b) ? a : b;
    assign ab_max = (a < b) ? b : a;

    // Stage 2: Compare and swap c, d
    wire [7:0] cd_min;
    wire [7:0] cd_max;
    assign cd_min = (c < d) ? c : d;
    assign cd_max = (c < d) ? d : c;

    // Stage 3: Compare and swap ab_min, cd_min
    wire [7:0] min_val;
    wire [7:0] max_val;
    assign min_val = (ab_min < cd_min) ? ab_min : cd_min;
    assign max_val = (ab_min < cd_min) ? cd_min : ab_min;

    // Output the minimum value
    assign min = min_val;

endmodule