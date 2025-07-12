module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enables: 4 stages (input, pprod sum1, sum2, final)
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: inputs and partial products
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (16 bits each)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: sum of partial products pairwise (4 sums)
    reg [15:0] sum_stage2 [3:0];

    // Stage 3 registers: sum of stage2 sums pairwise (2 sums)
    reg [15:0] sum_stage3 [1:0];

    // Stage 4 registers: final product
    reg [15:0] mul_out_reg;

    integer idx;

    // Stage 1: sample inputs and enable propagate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: sum partial products pairwise and register sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 4; idx = idx + 1)
                sum_stage2[idx] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (idx = 0; idx < 4; idx = idx + 1)
                sum_stage2[idx] <= 16'd0;
        end
    end

    // Stage 3: sum stage2 outputs pairwise and register sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
    end

    // Stage 4: final sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable aligned to final stage
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: output valid product when enabled, otherwise zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule