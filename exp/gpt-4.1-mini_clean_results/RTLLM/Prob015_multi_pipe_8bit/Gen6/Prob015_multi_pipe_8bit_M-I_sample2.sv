module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline registers for enable signals (4-stage pipeline)
    reg [3:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products generation
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: sum pairs of partial products into 4 sums
    reg [15:0] sum_stage2 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end
    end

    // Stage 3 registers: sum pairs of sums_stage2 into 2 sums
    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
    end

    // Stage 4 register: final sum to produce product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Input registers and enable pipeline
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

    // Output enable and product signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule