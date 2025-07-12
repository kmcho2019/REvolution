module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stage 0 registers (input stage)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_reg0;

    // Stage 1: Partial products generation and first level addition (4 adders)
    reg [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;
    reg        mul_en_reg1;

    // Stage 1 sums (pairwise adds of partial products)
    reg [15:0] sum_l1_0, sum_l1_1, sum_l1_2, sum_l1_3;
    reg        mul_en_reg2;

    // Stage 2 sums (add sums from stage 1 pairs)
    reg [15:0] sum_l2_0, sum_l2_1;
    reg        mul_en_reg3;

    // Stage 3 sum (final addition)
    reg [15:0] sum_final;
    reg        mul_en_reg4;

    // Output registers
    reg [15:0] mul_out_reg;

    // Stage 0: Sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_reg0 <= 1'b0;
        end else begin
            mul_en_reg0 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1: Generate partial products, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 16'd0;
            pp1 <= 16'd0;
            pp2 <= 16'd0;
            pp3 <= 16'd0;
            pp4 <= 16'd0;
            pp5 <= 16'd0;
            pp6 <= 16'd0;
            pp7 <= 16'd0;
            mul_en_reg1 <= 1'b0;
        end else begin
            mul_en_reg1 <= mul_en_reg0;
            // Generate partial products by shifting multiplicand if multiplier bit is 1
            pp0 <= mul_b_reg[0] ? {8'd0, mul_a_reg}           : 16'd0;
            pp1 <= mul_b_reg[1] ? ({7'd0, mul_a_reg} << 1)   : 16'd0;
            pp2 <= mul_b_reg[2] ? ({6'd0, mul_a_reg} << 2)   : 16'd0;
            pp3 <= mul_b_reg[3] ? ({5'd0, mul_a_reg} << 3)   : 16'd0;
            pp4 <= mul_b_reg[4] ? ({4'd0, mul_a_reg} << 4)   : 16'd0;
            pp5 <= mul_b_reg[5] ? ({3'd0, mul_a_reg} << 5)   : 16'd0;
            pp6 <= mul_b_reg[6] ? ({2'd0, mul_a_reg} << 6)   : 16'd0;
            pp7 <= mul_b_reg[7] ? ({1'd0, mul_a_reg} << 7)   : 16'd0;
        end
    end

    // Stage 2: First level addition (pairwise sums of partial products), register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_l1_0 <= 16'd0;
            sum_l1_1 <= 16'd0;
            sum_l1_2 <= 16'd0;
            sum_l1_3 <= 16'd0;
            mul_en_reg2 <= 1'b0;
        end else begin
            mul_en_reg2 <= mul_en_reg1;
            sum_l1_0 <= pp0 + pp1; // sum bits 0 and 1 partial products
            sum_l1_1 <= pp2 + pp3; // sum bits 2 and 3
            sum_l1_2 <= pp4 + pp5; // sum bits 4 and 5
            sum_l1_3 <= pp6 + pp7; // sum bits 6 and 7
        end
    end

    // Stage 3: Second level addition (sum pairs from first level), register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_l2_0 <= 16'd0;
            sum_l2_1 <= 16'd0;
            mul_en_reg3 <= 1'b0;
        end else begin
            mul_en_reg3 <= mul_en_reg2;
            sum_l2_0 <= sum_l1_0 + sum_l1_1;
            sum_l2_1 <= sum_l1_2 + sum_l1_3;
        end
    end

    // Stage 4: Final addition and register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_final <= 16'd0;
            mul_en_reg4 <= 1'b0;
        end else begin
            mul_en_reg4 <= mul_en_reg3;
            sum_final <= sum_l2_0 + sum_l2_1;
        end
    end

    // Stage 5: Output register stage, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            if (mul_en_reg4)
                mul_out_reg <= sum_final;
            else
                mul_out_reg <= 16'd0;
        end
    end

    // Output enable valid at last pipeline stage
    assign mul_en_out = mul_en_reg4;

    // Output product valid only when mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule