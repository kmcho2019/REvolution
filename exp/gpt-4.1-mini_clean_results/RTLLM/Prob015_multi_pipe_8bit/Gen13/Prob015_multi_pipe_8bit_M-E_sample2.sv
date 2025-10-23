module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: sample inputs and enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_stage1;

    // Stage 1 partial products (8 partial products of 16 bits each)
    reg [15:0] pp_reg [7:0]; // partial products registers at stage 1

    // Stage 2 registers: sums of partial products (pairwise addition)
    reg [15:0] sum_stage2 [3:0];
    reg        mul_en_stage2;

    // Stage 3 registers: final sum registers
    reg [15:0] sum_stage3 [1:0];
    reg        mul_en_stage3;

    // Stage 4 registers: final output product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage4;

    integer i;

    // Stage 1: Sample inputs and mul_en_in; generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_stage1 <= 1'b0;
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            // Generate partial products by ANDing mul_a bits with each bit of mul_b and shifting
            for (i = 0; i < 8; i = i + 1) begin
                if (mul_en_in)
                    pp_reg[i] <= mul_b[i] ? ({8'd0, mul_a} << i) : 16'd0;
                else
                    pp_reg[i] <= 16'd0; // Clear partial products if no valid input
            end
        end
    end

    // Stage 2: Pairwise add partial products from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i +1)
                sum_stage2[i] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;
            if (mul_en_stage1) begin
                sum_stage2[0] <= pp_reg[0] + pp_reg[1];
                sum_stage2[1] <= pp_reg[2] + pp_reg[3];
                sum_stage2[2] <= pp_reg[4] + pp_reg[5];
                sum_stage2[3] <= pp_reg[6] + pp_reg[7];
            end else begin
                for (i = 0; i < 4; i = i +1)
                    sum_stage2[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Sum pairs from stage 2 to reduce to two sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;
            if (mul_en_stage2) begin
                sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
                sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
            end else begin
                sum_stage3[0] <= 16'd0;
                sum_stage3[1] <= 16'd0;
            end
        end
    end

    // Stage 4: Final sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            mul_en_stage4 <= mul_en_stage3;
            if (mul_en_stage3) 
                mul_out_reg <= sum_stage3[0] + sum_stage3[1];
            else
                mul_out_reg <= 16'd0;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_stage4;
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule