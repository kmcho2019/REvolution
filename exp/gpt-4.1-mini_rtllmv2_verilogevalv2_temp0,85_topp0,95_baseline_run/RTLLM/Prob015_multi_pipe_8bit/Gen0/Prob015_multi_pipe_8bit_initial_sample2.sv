module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline registers for enable signal (8 stages)
    reg [7:0] mul_en_out_reg;

    // Input registers for multiplicand and multiplier (sampled when mul_en_in active)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: each bit of mul_b_reg selects mul_a_reg or zero
    wire [15:0] temp [7:0]; // 8 partial products shifted accordingly

    // Sum registers for pipeline accumulation of partial products
    reg [15:0] sum_stage1; // sum of partial products from bits 0,1
    reg [15:0] sum_stage2; // sum of partial products from bits 2,3
    reg [15:0] sum_stage3; // sum of partial products from bits 4,5
    reg [15:0] sum_stage4; // sum of partial products from bits 6,7

    reg [15:0] sum_stage5; // sum of stage1 + stage2
    reg [15:0] sum_stage6; // sum of stage3 + stage4

    reg [15:0] mul_out_reg; // final product register

    // Sample input enable and inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 8'd0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in}; // Shift in mul_en_in

            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products: if mul_b_reg[i] = 1, temp[i] = mul_a_reg << i else 0
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : PARTIAL_PRODUCT_GEN
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline addition stages to reduce partial products

    // Stage 1: sum pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 16'd0;
            sum_stage2 <= 16'd0;
            sum_stage3 <= 16'd0;
            sum_stage4 <= 16'd0;
        end else begin
            sum_stage1 <= temp[0] + temp[1];
            sum_stage2 <= temp[2] + temp[3];
            sum_stage3 <= temp[4] + temp[5];
            sum_stage4 <= temp[6] + temp[7];
        end
    end

    // Stage 2: sum pairs of sums from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage5 <= 16'd0;
            sum_stage6 <= 16'd0;
        end else begin
            sum_stage5 <= sum_stage1 + sum_stage2;
            sum_stage6 <= sum_stage3 + sum_stage4;
        end
    end

    // Stage 3: final sum to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            mul_out_reg <= sum_stage5 + sum_stage6;
        end
    end

    // Output enable is MSB of mul_en_out_reg (8-cycle latency)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= mul_en_out_reg[7];
        end
    end

    // Output product controlled by enable
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule