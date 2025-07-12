module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First stage: Parallel pairwise comparisons
    wire [7:0] stage1_min_ab = (a < b) ? a : b;
    wire [7:0] stage1_min_cd = (c < d) ? c : d;

    // Second stage: Compare stage winners
    assign min = (stage1_min_ab < stage1_min_cd) ? stage1_min_ab : stage1_min_cd;

endmodule