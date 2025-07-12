module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Pipeline registers for sums (8 bits each) and carries (1 bit)
    reg [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    reg       c1, c2, c3, c4, c5, c6, c7, c8;
    reg       en1, en2, en3, en4, en5, en6, en7, en8;

    wire [8:0] stage0_sum = {1'b0, adda[7:0]} + {1'b0, addb[7:0]} + 0;
    wire [8:0] stage1_sum = {1'b0, adda[15:8]} + {1'b0, addb[15:8]} + c1;
    wire [8:0] stage2_sum = {1'b0, adda[23:16]} + {1'b0, addb[23:16]} + c2;
    wire [8:0] stage3_sum = {1'b0, adda[31:24]} + {1'b0, addb[31:24]} + c3;
    wire [8:0] stage4_sum = {1'b0, adda[39:32]} + {1'b0, addb[39:32]} + c4;
    wire [8:0] stage5_sum = {1'b0, adda[47:40]} + {1'b0, addb[47:40]} + c5;
    wire [8:0] stage6_sum = {1'b0, adda[55:48]} + {1'b0, addb[55:48]} + c6;
    wire [8:0] stage7_sum = {1'b0, adda[63:56]} + {1'b0, addb[63:56]} + c7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 0; c1 <= 0; en1 <= 0;
            sum1 <= 0; c2 <= 0; en2 <= 0;
            sum2 <= 0; c3 <= 0; en3 <= 0;
            sum3 <= 0; c4 <= 0; en4 <= 0;
            sum4 <= 0; c5 <= 0; en5 <= 0;
            sum5 <= 0; c6 <= 0; en6 <= 0;
            sum6 <= 0; c7 <= 0; en7 <= 0;
            sum7 <= 0; c8 <= 0; en8 <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0
            sum0 <= stage0_sum[7:0];
            c1   <= stage0_sum[8];
            en1  <= i_en;

            // Stage 1
            sum1 <= stage1_sum[7:0];
            c2   <= stage1_sum[8];
            en2  <= en1;

            // Stage 2
            sum2 <= stage2_sum[7:0];
            c3   <= stage2_sum[8];
            en3  <= en2;

            // Stage 3
            sum3 <= stage3_sum[7:0];
            c4   <= stage3_sum[8];
            en4  <= en3;

            // Stage 4
            sum4 <= stage4_sum[7:0];
            c5   <= stage4_sum[8];
            en5  <= en4;

            // Stage 5
            sum5 <= stage5_sum[7:0];
            c6   <= stage5_sum[8];
            en6  <= en5;

            // Stage 6
            sum6 <= stage6_sum[7:0];
            c7   <= stage6_sum[8];
            en7  <= en6;

            // Stage 7
            sum7 <= stage7_sum[7:0];
            c8   <= stage7_sum[8];
            en8  <= en7;

            // Output register and enable when pipeline valid
            if (en8) begin
                result <= {c8, sum7, sum6, sum5, sum4, sum3, sum2, sum1, sum0};
                o_en <= 1'b1;
            end else begin
                result <= 0;
                o_en <= 1'b0;
            end
        end
    end

endmodule