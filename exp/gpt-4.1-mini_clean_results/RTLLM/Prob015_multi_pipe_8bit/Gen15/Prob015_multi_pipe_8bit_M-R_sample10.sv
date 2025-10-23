module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: input sampling and partial product generation
    reg         mul_en_stage1;
    reg  [7:0]  mul_a_stage1;
    reg  [7:0]  mul_b_stage1;

    reg [15:0]  partial_products_reg [7:0];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage1 <= 1'b0;
            mul_a_stage1  <= 8'd0;
            mul_b_stage1  <= 8'd0;
            for (i = 0; i < 8; i = i +1) begin
                partial_products_reg[i] <= 16'd0;
            end
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_stage1 <= mul_a;
                mul_b_stage1 <= mul_b;
                // Generate partial products: if mul_b_stage1[i] == 1, then mul_a_stage1 << i else 0
                for (i = 0; i < 8; i = i +1) begin
                    partial_products_reg[i] <= mul_b[i] ? (mul_a << i) : 16'd0;
                end
            end else begin
                // If not enabled, clear partial products
                for (i = 0; i < 8; i = i +1) begin
                    partial_products_reg[i] <= 16'd0;
                end
            end
        end
    end

    // Stage 2 registers: pipeline the sums of partial products using a balanced adder tree

    // First level sums (4 sums)
    reg [15:0] sum_level1 [3:0];
    // Second level sums (2 sums)
    reg [15:0] sum_level2 [1:0];
    // Final level sum (1 sum)
    reg [15:0] sum_final;

    reg mul_en_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level1[0] <= 16'd0;
            sum_level1[1] <= 16'd0;
            sum_level1[2] <= 16'd0;
            sum_level1[3] <= 16'd0;
            sum_level2[0] <= 16'd0;
            sum_level2[1] <= 16'd0;
            sum_final     <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;

            // Sum pairs of partial products
            sum_level1[0] <= partial_products_reg[0] + partial_products_reg[1];
            sum_level1[1] <= partial_products_reg[2] + partial_products_reg[3];
            sum_level1[2] <= partial_products_reg[4] + partial_products_reg[5];
            sum_level1[3] <= partial_products_reg[6] + partial_products_reg[7];

            // Sum pairs of sums from previous level
            sum_level2[0] <= sum_level1[0] + sum_level1[1];
            sum_level2[1] <= sum_level1[2] + sum_level1[3];

            // Final sum
            sum_final <= sum_level2[0] + sum_level2[1];
        end
    end

    // Output enable and product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_stage2;
            mul_out    <= mul_en_stage2 ? sum_final : 16'd0;
        end
    end

endmodule