module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers for enable signal (8 stages for pipeline latency)
    reg [7:0] mul_en_out_reg;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (8 partial products, each shifted accordingly)
    wire [15:0] partial_products [7:0];

    // Stage 1: Input sampling and partial product generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 8'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            // Shift enable pipeline
            mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};
            // Sample inputs only when mul_en_in is high
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products: each is multiplicand AND multiplier bit,
    // then shifted by bit position.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline registers for accumulating partial sums
    // We'll accumulate partial products in pairs in stages to pipeline the additions.
    // Stage 2 registers
    reg [15:0] sum_stage2_0;
    reg [15:0] sum_stage2_1;
    reg [15:0] sum_stage2_2;
    reg [15:0] sum_stage2_3;

    // Stage 3 registers
    reg [15:0] sum_stage3_0;
    reg [15:0] sum_stage3_1;

    // Stage 4 register (final sum)
    reg [15:0] mul_out_reg;

    // Stage 2: Add pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= 16'b0;
            sum_stage2_1 <= 16'b0;
            sum_stage2_2 <= 16'b0;
            sum_stage2_3 <= 16'b0;
        end else begin
            sum_stage2_0 <= partial_products[0] + partial_products[1];
            sum_stage2_1 <= partial_products[2] + partial_products[3];
            sum_stage2_2 <= partial_products[4] + partial_products[5];
            sum_stage2_3 <= partial_products[6] + partial_products[7];
        end
    end

    // Stage 3: Add pairs of sums from stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_0 <= 16'b0;
            sum_stage3_1 <= 16'b0;
        end else begin
            sum_stage3_0 <= sum_stage2_0 + sum_stage2_1;
            sum_stage3_1 <= sum_stage2_2 + sum_stage2_3;
        end
    end

    // Stage 4: Final sum to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else begin
            mul_out_reg <= sum_stage3_0 + sum_stage3_1;
        end
    end

    // Output enable is the MSB of mul_en_out_reg (after 8 pipeline stages)
    assign mul_en_out = mul_en_out_reg[7];

    // Output product valid only when mul_en_out is asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule