module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline stage 1: input registers and enable pipeline
reg [7:0] stage1_mul_a;
reg [7:0] stage1_mul_b;
reg       stage1_en;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_mul_a <= 8'd0;
        stage1_mul_b <= 8'd0;
        stage1_en    <= 1'b0;
    end else begin
        stage1_en    <= mul_en_in;
        if (mul_en_in) begin
            stage1_mul_a <= mul_a;
            stage1_mul_b <= mul_b;
        end
    end
end

// Pipeline stage 2: partial product generation
// Generate partial products, each shifted accordingly and zero if multiplier bit not set or enable is low
reg [15:0] stage2_partial[7:0];
reg        stage2_en;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=0; i<8; i=i+1) begin
            stage2_partial[i] <= 16'd0;
        end
        stage2_en <= 1'b0;
    end else begin
        stage2_en <= stage1_en;
        for (i=0; i<8; i=i+1) begin
            if (stage1_en && stage1_mul_b[i])
                stage2_partial[i] <= {8'd0, stage1_mul_a} << i;
            else
                stage2_partial[i] <= 16'd0;
        end
    end
end

// Pipeline stage 3: balanced adder tree for partial sums
reg [15:0] sum_level1[3:0];
reg [15:0] sum_level2[1:0];
reg [15:0] sum_level3;
reg        stage3_en;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=0; i<4; i=i+1) begin
            sum_level1[i] <= 16'd0;
        end
        sum_level2[0] <= 16'd0;
        sum_level2[1] <= 16'd0;
        sum_level3    <= 16'd0;
        stage3_en     <= 1'b0;
    end else begin
        stage3_en <= stage2_en;
        // Level 1 sums: pairs of partial products
        sum_level1[0] <= stage2_partial[0] + stage2_partial[1];
        sum_level1[1] <= stage2_partial[2] + stage2_partial[3];
        sum_level1[2] <= stage2_partial[4] + stage2_partial[5];
        sum_level1[3] <= stage2_partial[6] + stage2_partial[7];

        // Level 2 sums: pairs of level 1 sums
        sum_level2[0] <= sum_level1[0] + sum_level1[1];
        sum_level2[1] <= sum_level1[2] + sum_level1[3];

        // Level 3 sum: final product sum
        sum_level3    <= sum_level2[0] + sum_level2[1];
    end
end

// Output registers and enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= stage3_en;
        mul_out    <= stage3_en ? sum_level3 : 16'd0;
    end
end

endmodule