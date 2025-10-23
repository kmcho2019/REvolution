module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output              mul_en_out,
    output      [15:0]  mul_out
);

    // Pipeline enable shift register (4 stages: input + 3 pipeline stages)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers (sample inputs and input enable)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products generation (combinational)
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: sum partial products pairwise (4 sums)
    reg [15:0] sum_stage2 [3:0];

    // Stage 3 registers: sum Stage 2 sums pairwise (2 sums)
    reg [15:0] sum_stage3 [1:0];

    // Stage 4 register: final product (sum of two sums from Stage 3)
    reg [15:0] mul_out_reg;

    // Enable signals synchronized to pipeline stages
    // mul_en_pipe[0] - input stage
    // mul_en_pipe[1] - stage 2 sums valid
    // mul_en_pipe[2] - stage 3 sums valid
    // mul_en_pipe[3] - final output valid

    // Input capture and enable propagation
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

    // Stage 2: Register pairwise sums of partial products and propagate enable
    // sums: (0+1), (2+3), (4+5), (6+7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            // Clear sums when not enabled to avoid glitching downstream
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end
    end

    // Stage 3: Register sums of Stage 2 sums pairwise: (0+1), (2+3)
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

    // Stage 4: Register final product: sum Stage 3 sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable is MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[3];

    // Output product gated by enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule