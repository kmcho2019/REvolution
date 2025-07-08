module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output             mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline stage 1 registers: input capture and enable
    reg            mul_en_stage1;
    reg [7:0]      mul_a_reg;
    reg [7:0]      mul_b_reg;

    // Partial products wires - each 16 bits because shifted appropriately
    wire [15:0] partial_products [7:0];

    // Generate partial products: if mul_b_reg[i] == 1, partial product = mul_a_reg shifted by i, else 0
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? ( {8'b0, mul_a_reg} << i ) : 16'b0;
        end
    endgenerate

    // Pipeline stage 2 registers: partial sums, sum1 and enable
    reg            mul_en_stage2;
    reg [15:0]     sum1_0, sum1_1, sum1_2, sum1_3;

    // Pipeline stage 3 registers: partial sums sum2 and enable
    reg            mul_en_stage3;
    reg [15:0]     sum2_0, sum2_1;

    // Pipeline stage 4 registers: final sum and enable
    reg            mul_en_stage4;
    reg [15:0]     mul_out_reg;

    // Stage 1: input capture and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage1 <= 1'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: sum partial_products in pairs (4 sums), register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage2 <= 1'b0;
            sum1_0 <= 16'b0;
            sum1_1 <= 16'b0;
            sum1_2 <= 16'b0;
            sum1_3 <= 16'b0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;
            if (mul_en_stage1) begin
                sum1_0 <= partial_products[0] + partial_products[1];
                sum1_1 <= partial_products[2] + partial_products[3];
                sum1_2 <= partial_products[4] + partial_products[5];
                sum1_3 <= partial_products[6] + partial_products[7];
            end else begin
                sum1_0 <= 16'b0;
                sum1_1 <= 16'b0;
                sum1_2 <= 16'b0;
                sum1_3 <= 16'b0;
            end
        end
    end

    // Stage 3: sum the 4 sums into 2 sums, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage3 <= 1'b0;
            sum2_0 <= 16'b0;
            sum2_1 <= 16'b0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;
            if (mul_en_stage2) begin
                sum2_0 <= sum1_0 + sum1_1;
                sum2_1 <= sum1_2 + sum1_3;
            end else begin
                sum2_0 <= 16'b0;
                sum2_1 <= 16'b0;
            end
        end
    end

    // Stage 4: final sum and register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage4 <= 1'b0;
            mul_out_reg <= 16'b0;
        end else begin
            mul_en_stage4 <= mul_en_stage3;
            if (mul_en_stage3) begin
                mul_out_reg <= sum2_0 + sum2_1;
            end else begin
                mul_out_reg <= 16'b0;
            end
        end
    end

    // Output enable is the last stage's enable
    assign mul_en_out = mul_en_stage4;

    // Output product is valid only when mul_en_out is high, else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'b0;
    end

endmodule