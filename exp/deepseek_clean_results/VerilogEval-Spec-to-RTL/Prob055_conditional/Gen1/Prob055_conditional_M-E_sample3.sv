module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    reg [7:0] stage1_min_ab;
    reg [7:0] stage1_min_cd;

    always @(*) begin
        // First stage: parallel comparisons
        stage1_min_ab = (a < b) ? a : b;
        stage1_min_cd = (c < d) ? c : d;

        // Second stage: compare winners
        min = (stage1_min_ab < stage1_min_cd) ? stage1_min_ab : stage1_min_cd;
    end

endmodule