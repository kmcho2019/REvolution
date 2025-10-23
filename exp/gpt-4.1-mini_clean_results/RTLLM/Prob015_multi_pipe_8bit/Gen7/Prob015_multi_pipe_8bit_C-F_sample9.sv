module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // 4-stage enable pipeline to align with pipeline latency
    reg [3:0] mul_en_pipe;

    // Input operand registers, only update when mul_en_in is asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: wires derived from mul_b_reg bits and shifted mul_a_reg
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline stage 1: sum pairs of partial products (4 sums)
    reg [15:0] sum_stage1 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1[0] <= 16'd0;
            sum_stage1[1] <= 16'd0;
            sum_stage1[2] <= 16'd0;
            sum_stage1[3] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum_stage1[0] <= partial_products[0] + partial_products[1];
            sum_stage1[1] <= partial_products[2] + partial_products[3];
            sum_stage1[2] <= partial_products[4] + partial_products[5];
            sum_stage1[3] <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage1[0] <= 16'd0;
            sum_stage1[1] <= 16'd0;
            sum_stage1[2] <= 16'd0;
            sum_stage1[3] <= 16'd0;
        end
    end

    // Pipeline stage 2: sum pairs of sums from stage 1 (2 sums)
    reg [15:0] sum_stage2 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
            sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
        end else begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
        end
    end

    // Pipeline stage 3: final sum of two sums from stage 2 to produce product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage2[0] + sum_stage2[1];
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

    // Output enable is the last stage of enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // Output mux: valid product only when mul_en_out is high, else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule