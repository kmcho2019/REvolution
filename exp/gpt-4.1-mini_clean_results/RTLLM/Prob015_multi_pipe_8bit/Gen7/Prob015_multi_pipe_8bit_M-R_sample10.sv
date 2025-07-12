module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stage enables
    reg mul_en_stage0, mul_en_stage1, mul_en_stage2, mul_en_stage3;

    // Stage 0: input registers for mul_a and mul_b
    reg [7:0] mul_a_reg_stage0;
    reg [7:0] mul_b_reg_stage0;

    // Partial products (combinational) from stage 0 registered inputs
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b_reg_stage0[i] ? (mul_a_reg_stage0 << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Registers for two partial sums (sum of partial_products[0..3], sum of partial_products[4..7])
    reg [15:0] sum_low_stage1;
    reg [15:0] sum_high_stage1;

    // Stage 2: Registers to hold sums from stage 1
    reg [15:0] sum_low_stage2;
    reg [15:0] sum_high_stage2;

    // Stage 3: Register for final product output
    reg [15:0] mul_out_reg;

    // Pipeline enable registers shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage0 <= 1'b0;
            mul_en_stage1 <= 1'b0;
            mul_en_stage2 <= 1'b0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_en_stage0 <= mul_en_in;
            mul_en_stage1 <= mul_en_stage0;
            mul_en_stage2 <= mul_en_stage1;
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Stage 0: Capture inputs when enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg_stage0 <= 8'b0;
            mul_b_reg_stage0 <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg_stage0 <= mul_a;
            mul_b_reg_stage0 <= mul_b;
        end
    end

    // Stage 1: Sum partial products groups when enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_stage1 <= 16'b0;
            sum_high_stage1 <= 16'b0;
        end else if (mul_en_stage1) begin
            sum_low_stage1  <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
            sum_high_stage1 <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
        end else begin
            sum_low_stage1  <= 16'b0;
            sum_high_stage1 <= 16'b0;
        end
    end

    // Stage 2: Register sums from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_stage2  <= 16'b0;
            sum_high_stage2 <= 16'b0;
        end else if (mul_en_stage2) begin
            sum_low_stage2  <= sum_low_stage1;
            sum_high_stage2 <= sum_high_stage1;
        end else begin
            sum_low_stage2  <= 16'b0;
            sum_high_stage2 <= 16'b0;
        end
    end

    // Stage 3: Final product summation and register output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_stage3) begin
            mul_out_reg <= sum_low_stage2 + sum_high_stage2;
        end else begin
            mul_out_reg <= 16'b0;
        end
    end

    // Output enable is enable of final stage
    assign mul_en_out = mul_en_stage3;

    // Output product only valid if enabled; else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule